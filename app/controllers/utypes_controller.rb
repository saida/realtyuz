class UtypesController < ApplicationController
  # GET /utypes
  # GET /utypes.xml
  def index
    @utypes = Utype.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @utypes }
      format.json { render :json => @utypes }
    end
  end

  # GET /utypes/new
  # GET /utypes/new.xml
  def new
    @utype = Utype.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @utype }
    end
  end

  # GET /utypes/1/edit
  def edit
    @utype = Utype.find(params[:id])
  end

  # POST /utypes
  # POST /utypes.xml
  def create
    @utype = Utype.new(params[:utype])

    respond_to do |format|
      if @utype.save
        format.html { redirect_to(utypes_url, :notice => 'User type was successfully created.') }
        format.xml  { render :xml => @utype, :status => :created, :location => @utype }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @utype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /utypes/1
  # PUT /utypes/1.xml
  def update
    @utype = Utype.find(params[:id])

    respond_to do |format|
      if @utype.update_attributes(params[:utype])
        format.html { redirect_to(utypes_url, :notice => 'User type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @utype.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /utypes/1
  # DELETE /utypes/1.xml
  def destroy
    @utype = Utype.find(params[:id])
    @utype.destroy

    respond_to do |format|
      format.html { redirect_to(utypes_url) }
      format.xml  { head :ok }
    end
  end
end
