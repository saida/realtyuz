class PtypesController < ApplicationController
  skip_before_filter :login_required
  # GET /ptypes
  # GET /ptypes.xml
  def index
    @ptypes = Ptype.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ptypes }
      format.json { render :json => @ptypes }
    end
  end

  # GET /ptypes/new
  # GET /ptypes/new.xml
  def new
    @ptype = Ptype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ptype }
    end
  end

  # GET /ptypes/1/edit
  def edit
    @ptype = Ptype.find(params[:id])
  end

  # POST /ptypes
  # POST /ptypes.xml
  def create
    @ptype = Ptype.new(params[:ptype])

    respond_to do |format|
      if @ptype.save
        format.html { redirect_to(ptypes_url, :notice => 'Property type was successfully created.') }
        format.xml  { render :xml => @ptype, :status => :created, :location => @ptype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ptype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ptypes/1
  # PUT /ptypes/1.xml
  def update
    @ptype = Ptype.find(params[:id])

    respond_to do |format|
      if @ptype.update_attributes(params[:ptype])
        format.html { redirect_to(ptypes_url, :notice => 'Property type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ptype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ptypes/1
  # DELETE /ptypes/1.xml
  def destroy
    @ptype = Ptype.find(params[:id])
    @ptype.destroy

    respond_to do |format|
      format.html { redirect_to(ptypes_url) }
      format.xml  { head :ok }
    end
  end
end
