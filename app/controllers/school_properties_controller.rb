class SchoolPropertiesController < ApplicationController
  # GET /school_properties
  # GET /school_properties.xml
  def index
    @school_properties = SchoolProperty.find(:all, :include => [:school, :property, :transport])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_properties }
      format.json { render :json => @school_properties }
    end
  end

  # GET /school_properties/1
  # GET /school_properties/1.xml
  def show
    @school_property = SchoolProperty.find(params[:id], :include => [:school, :property, :transport])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_property }
    end
  end

  # GET /school_properties/new
  # GET /school_properties/new.xml
  def new
    @school_property = SchoolProperty.new
    list

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school_property }
    end
  end

  # GET /school_properties/1/edit
  def edit
    @school_property = SchoolProperty.find(params[:id])
    list
  end

  # POST /school_properties
  # POST /school_properties.xml
  def create
    @school_property = SchoolProperty.new(params[:school_property])
    list

    respond_to do |format|
      if @school_property.save
        format.html { redirect_to(@school_property, :notice => 'SchoolProperty was successfully created.') }
        format.xml  { render :xml => @school_property, :status => :created, :location => @school_property }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school_property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_properties/1
  # PUT /school_properties/1.xml
  def update
    @school_property = SchoolProperty.find(params[:id])
    list

    respond_to do |format|
      if @school_property.update_attributes(params[:school_property])
        format.html { redirect_to(@school_property, :notice => 'SchoolProperty was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school_property.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_properties/1
  # DELETE /school_properties/1.xml
  def destroy
    @school_property = SchoolProperty.find(params[:id])
    @school_property.destroy

    respond_to do |format|
      format.html { redirect_to(school_properties_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @schools = School.all.collect { |s| [s.name, s.id] }
    @properties = Property.all.collect { |p| [p.id] }
    @transports = Transport.all.collect { |t| [t.name, t.id] }
  end
end
