class MetroPropertiesController < ApplicationController
  # GET /metro_properties
  # GET /metro_properties.xml
  def index
    @metro_properties = MetroProperty.find(:all, :include => [:metro, :property, :transport])
    @metros = Metro.all
    @properties = Property.all
    @transports = Transport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @metro_properties }
      format.json { render :json => @metro_properties }
    end
  end

  # GET /metro_properties/1
  # GET /metro_properties/1.xml
  def show
    @metro_property = MetroProperty.find(params[:id], :include => [:metro, :property, :transport])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @metro_property }
    end
  end

  # GET /metro_properties/new
  # GET /metro_properties/new.xml
  def new
    @metro_property = MetroProperty.new
    list
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @metro_property }
    end
  end

  # GET /metro_properties/1/edit
  def edit
    @metro_property = MetroProperty.find(params[:id])
    list
  end

  # POST /metro_properties
  # POST /metro_properties.xml
  def create
    @metro_property = MetroProperty.new(params[:metro_property])
    list

    respond_to do |format|
      if @metro_property.save
        format.html { redirect_to(@metro_property, :notice => 'MetroProperty was successfully created.') }
        format.xml  { render :xml => @metro_property, :status => :created, :location => @metro_property }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metro_property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /metro_properties/1
  # PUT /metro_properties/1.xml
  def update
    @metro_property = MetroProperty.find(params[:id])
    list

    respond_to do |format|
      if @metro_property.update_attributes(params[:metro_property])
        format.html { redirect_to(@metro_property, :notice => 'MetroProperty was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metro_property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metro_properties/1
  # DELETE /metro_properties/1.xml
  def destroy
    @metro_property = MetroProperty.find(params[:id])
    @metro_property.destroy

    respond_to do |format|
      format.html { redirect_to(metro_properties_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @metros = Metro.all.collect { |m| [m.name, m.id] }
    @properties = Property.all.collect { |p| [p.id] }
    @transports = Transport.all.collect { |t| [t.name, t.id] }
  end
end
