class SchoolsController < ApplicationController
  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.find(:all, :include => [:region, :city, :district])
    @regions = Region.all
    @cities = City.all
    @districts = District.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
      format.json { render :json => @schools }
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
  
  # GET /schools/1
  # GET /schools/1.xml
  def show
    @school = School.find(params[:id], :include => [:region, :city, :district])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    list
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
    list
  end

  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])
    list

    respond_to do |format|
      if @school.save
        format.html { redirect_to(@school, :notice => 'School was successfully created.') }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    @school = School.find(params[:id])
    list

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to(@school, :notice => 'School was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.destroy

    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @regions = Region.all.collect {|r| [r.region_name, r.id] }
    @cities = City.all.collect {|c| [c.city_name, c.id] }
    @districts = District.all.collect {|d| [d.district_name, d.id] }
  end
end
