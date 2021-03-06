class CitiesController < ApplicationController
  skip_before_filter :login_required
  # GET /cities
  # GET /cities.xml
  def index
    @cities = City.find(:all, :order => 'region_id, city_name', :include => :region)
    @regions = Region.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
      format.json { render :json => @cities }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])
    
    respond_to do |format|
      if @city.save
        format.html { redirect_to(:action => :index, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(:action => :index, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    begin
      @city.destroy
      flash[:notice] = "City was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end
end
