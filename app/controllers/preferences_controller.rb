class PreferencesController < ApplicationController
  layout 'realestate'
  # GET /preferences
  # GET /preferences.xml
  def index
    @preferences = Preference.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preferences }
    end
  end
  
  def update_cities
    # updates cities and districts based on region selected
    if params[:region_id] and params[:region_id] != ''
      @region = Region.find(params[:region_id])
      @cities = @region.cities.all.collect {|c| [c.city_name, c.id] }
      @districts = @region.districts.all.collect {|d| [d.district_name, d.id] }
    else
      @cities = City.all
    end
    render :update do |page|
      if !@region.nil? and !@cities.blank?
        page.replace_html 'cities', :partial => 'cities', :object => @cities
        page.show 'cities'
        if !@districts.blank?
          page.replace_html 'districts', :partial => 'districts', :object => @districts          
          page.show 'districts'
        else
          page.hide 'districts'
        end
      elsif params[:region_id] == ''
        page.hide 'cities', 'districts'
      end
    end
  end
  
  def update_districts
    # updates districts based on city selected
    if params[:city_id] and params[:city_id] != ''
      @city = City.find(params[:city_id])
      @districts = @city.districts.all.collect {|d| [d.district_name, d.id] }
    else
      @districts = nil
    end
    render :update do |page|
      if !@districts.blank?
        page.replace_html 'districts', :partial => 'districts', :object => @districts          
        page.show 'districts'
      else
        page.hide 'districts'
      end
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference = Preference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/new
  # GET /preferences/new.xml
  def new
    @preference = Preference.new
    @preference.user_id = current_account.id
    list
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
    @preference = Preference.find(params[:id])
    list
  end

  # POST /preferences
  # POST /preferences.xml
  def create
    @preference = Preference.new(params[:preference])
    @preference.user_id = current_account.id
    list
    respond_to do |format|
      if @preference.save
        format.html { redirect_to(@preference, :notice => 'Preference was successfully created.') }
        format.xml  { render :xml => @preference, :status => :created, :location => @preference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])
    list
    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        format.html { redirect_to(@preference, :notice => 'Preference was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.xml
  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    respond_to do |format|
      format.html { redirect_to(preferences_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @categories = Category.all.collect {|ct| [ct.name, ct.id] }
    @ptypes = Ptype.all.collect {|pt| [pt.ptype_name, pt.id] }
    @sellers = User.all.collect {|s| [s.fname.to_s + ' ' + s.lname.to_s, s.id] }
    @rooms = Room.all.collect {|rm| [rm.name, rm.id] }
    @regions = Region.all.collect {|r| [r.region_name, r.id] }
    @cities = City.all.collect {|c| [c.city_name, c.id] }
    @districts = District.all.collect {|d| [d.district_name, d.id] }
    @metros = Metro.all.collect {|m| [m.name, m.id] }
    @schools = School.all.collect {|sch| [sch.name, sch.id] }
    @transports = Transport.all.collect {|t| [t.name, t.id] }
    @materials = Material.all.collect {|mat| [mat.name, mat.id] }
  end
end
