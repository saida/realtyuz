class MetrosController < ApplicationController
  # GET /metros
  # GET /metros.xml
  def index
    @metros = Metro.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @metros }
      format.json { render :json => @metros }
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

  # GET /metros/1
  # GET /metros/1.xml
  def show
    @metro = Metro.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @metro }
    end
  end

  # GET /metros/new
  # GET /metros/new.xml
  def new
    @metro = Metro.new
    list

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @metro }
    end
  end

  # GET /metros/1/edit
  def edit
    @metro = Metro.find(params[:id])
    list
  end

  # POST /metros
  # POST /metros.xml
  def create
    @metro = Metro.new(params[:metro])
    list
    
    respond_to do |format|
      if @metro.save
        format.html { redirect_to(@metro, :notice => 'Metro was successfully created.') }
        format.xml  { render :xml => @metro, :status => :created, :location => @metro }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /metros/1
  # PUT /metros/1.xml
  def update
    @metro = Metro.find(params[:id])
    list
    
    respond_to do |format|
      if @metro.update_attributes(params[:metro])
        format.html { redirect_to(@metro, :notice => 'Metro was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metro.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metros/1
  # DELETE /metros/1.xml
  def destroy
    @metro = Metro.find(params[:id])
    @metro.destroy

    respond_to do |format|
      format.html { redirect_to(metros_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @regions = Region.all.collect {|r| [r.region_name, r.id] }
    @cities = City.all.collect {|c| [c.city_name, c.id] }
    @districts = District.all.collect {|d| [d.district_name, d.id] }
  end
end
