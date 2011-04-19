class ArtCategoriesController < ApplicationController
  # GET /art_categories
  # GET /art_categories.xml
  def index
    @art_categories = ArtCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @art_categories }
    end
  end

  # GET /art_categories/1
  # GET /art_categories/1.xml
  def show
    @art_category = ArtCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @art_category }
    end
  end

  # GET /art_categories/new
  # GET /art_categories/new.xml
  def new
    @art_category = ArtCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @art_category }
    end
  end

  # GET /art_categories/1/edit
  def edit
    @art_category = ArtCategory.find(params[:id])
  end

  # POST /art_categories
  # POST /art_categories.xml
  def create
    @art_category = ArtCategory.new(params[:art_category])

    respond_to do |format|
      if @art_category.save
        format.html { redirect_to(@art_category, :notice => 'ArtCategory was successfully created.') }
        format.xml  { render :xml => @art_category, :status => :created, :location => @art_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @art_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /art_categories/1
  # PUT /art_categories/1.xml
  def update
    @art_category = ArtCategory.find(params[:id])

    respond_to do |format|
      if @art_category.update_attributes(params[:art_category])
        format.html { redirect_to(@art_category, :notice => 'ArtCategory was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @art_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /art_categories/1
  # DELETE /art_categories/1.xml
  def destroy
    @art_category = ArtCategory.find(params[:id])
    @art_category.destroy

    respond_to do |format|
      format.html { redirect_to(art_categories_url) }
      format.xml  { head :ok }
    end
  end
end
