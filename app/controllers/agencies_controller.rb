class AgenciesController < ApplicationController
  # GET /agencies
  # GET /agencies.xml
  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agencies }
      format.json { render :json => @agencies }
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
        if page['cities'].visible
          page.replace_html 'cities', :partial => 'cities', :object => @cities
        else
          page.insert_html :after, 'cities', :partial => 'cities', :object => @cities
        end
      elsif params[:region_id] == ''
        page.hide 'cities'
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
        if page['districts'].visible
          page.replace_html 'districts', :partial => 'districts', :object => @districts          
        else
          page.insert_html :after, 'districts', :partial => 'districts', :object => @districts
        end
      else
        page.hide 'districts'
      end
    end
  end

  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    @agency = Agency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/new
  # GET /agencies/new.xml
  def new
    @agency = Agency.new
    list
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/1/edit
  def edit
    @agency = Agency.find(params[:id])
    list
  end

  # POST /agencies
  # POST /agencies.xml
  def create
    @agency = Agency.new(params[:agency])
    list
    
    respond_to do |format|
      if @agency.save
        format.html { redirect_to(@agency, :notice => 'Agency was successfully created.') }
        format.xml  { render :xml => @agency, :status => :created, :location => @agency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
    @agency = Agency.find(params[:id])
    list

    respond_to do |format|
      if @agency.update_attributes(params[:agency])
        format.html { redirect_to(@agency, :notice => 'Agency was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agency.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def change_photo
    @agency = Agency.find(params[:id])
    
    render :update do |page|
      page.insert_html :after, 'change_photo', :partial => 'change_photo', :object => @agency
      page.hide 'link_to_change'
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.xml
  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy

    respond_to do |format|
      format.html { redirect_to(agencies_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @regions = Region.all.collect {|r| [r.region_name, r.id] }
    @cities = City.all.collect {|c| [c.city_name, c.id] }
    @districts = District.all.collect {|d| [d.district_name, d.id] }
  end
end
