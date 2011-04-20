class PropertiesController < ApplicationController
  
  skip_before_filter :login_required #, :only => ['new', 'create']
  
  # GET /properties
  # GET /properties.xml
  def index
    @properties = Property.search([], params[:page], 'created_at DESC')
    @categories = Category.all
    @rooms = Room.all
    @regions = Region.all
    @cities = City.all
    @districts = District.all
    
    for asset in Asset.all do
      if !asset.data_file_name
        asset.destroy
      end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.js {
        render :update do |page|
          page.replace_html 'properties', :partial => 'properties', :object => @properties
        end
      }
      format.xml { render :xml => @properties }
      format.json { render :json => Property.all(:order => 'created_at DESC') }
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
  
  # GET /properties/1
  # GET /properties/1.xml
  def show
    @property = Property.find(params[:id], :include => [:ptype, :region, :city, :district])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @property }
    end
  end
  
  def show_photo
    @asset = Asset.find(params[:id])
    if request.xhr?
      render :update do |page|
        page.replace_html 'bigphoto', "<img src= #{@asset.url(:large)} width='350px'><br /><center><h3>#{@asset.description}</h3></center>"
      end
    else
      render @asset.url(:large)
    end
  end

  # GET /properties/new
  # GET /properties/new.xml
  def new
    if current_account
      @property = Property.new
      @property.seller_id = current_account.id
      list
   
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @property }
      end
    else
      flash[:notice] = "You have to be logged in to add a listing."
      
      render :update do |page|
        page.insert_html :before, 'content', "<div id='notice'>#{flash[:notice]}</div>"
        page["notice"].visual_effect :fade, :duration => 4
      end
    end
  end

  # GET /properties/1/edit
  def edit
    @property = Property.find(params[:id])
    list
  end

  # POST /properties
  # POST /properties.xml
  def create
    w = {}
    params.each do |k, v|
      if k =~ /^c_(.+)$/
        w[$1] = 1
      end
    end

    @property = Property.new(params[:property])
    @property.details = Base64.encode64(w.to_json).gsub("\n", "")
    @property.seller_id = current_account.id
    list

    @property.assets.each do |a|
      if !a.data_file_name
        begin
          a.destroy
        rescue Exception => e
          flash[:notice] = e.message
        end
      end
    end

    respond_to do |format|
      valid = @property.save

      if valid
        Preference.find(:all, :conditions => [
          "(region_id is null or region_id=#{@property.region_id}) And (city_id is null or city_id=#{@property.city_id}) And (ptype_id is null or ptype_id=#{@property.ptype_id}) And " +
          "(minprice is null or minprice<=#{@property.price}) And (maxprice is null or maxprice>=#{@property.price}) And " +
          "(pcategory_id is null or pcategory_id=#{@property.category_id}) And (minarea is null or minarea<=#{@property.area}) And (maxarea is null or maxarea<=#{@property.area}) And " +
          "(material_id is null or material_id=#{@property.material_id}) And (floor is null or floor=#{@property.floor}) And (floors is null or floors=#{@property.floors}) And " +
          "(room_id is null or room_id=#{@property.room_id})"
        ]).each do |preferences|
          # send email
          AccountMailer.deliver_preference(@property, preference, "http://realtyuz.com/realestate/show_property/#{@property.id}")
        end
      end

      if current_account.has_role?("administrator") and !params[:adding]
        if valid
          #flash[:notice] = "Property successfully created!"
          format.html { redirect_to(@property, :notice => 'Property was successfully created.') }
          format.xml  { render :xml => @property, :status => :created, :location => @property }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
        end
      else
        if valid
          format.html { redirect_to(:controller => 'realestate', :action => 'add_property', :object => @property, :notice => 'Property was successfully created.') }
        else
          format.html { redirect_to(:controller => 'realestate', :action => 'add_property', :object => @property, :error => 'Property was not created.') }
        end
      end
    end
  end

  # PUT /properties/1
  # PUT /properties/1.xml
  def update
    w = {}
    params.each do |k, v|
      if k =~ /^c_(.+)$/
        w[$1] = 1
      end
    end

    @property = Property.find(params[:id])
    @property.details = Base64.encode64(w.to_json).gsub("\n", "")
    list
    
    respond_to do |format|
      if current_account.has_role?("administrator") and !params[:editing]
        if @property.update_attributes(params[:property])
          format.html { redirect_to(@property, :notice => 'Property was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @property.errors, :status => :unprocessable_entity }
        end
      else
        if @property.update_attributes(params[:property])
           format.html { redirect_to(:controller => 'realestate', :action => 'show_property', :id => @property, :notice => 'Property was successfully updated.') }
         else
           format.html { redirect_to(:controller => 'realestate', :action => 'edit_property', :id => @property, :error => 'Property was not updated.') }
         end
      end
    end
  end
  
  def delete_asset
    @property = Property.find(params[:id])
    @asset = Asset.find(params[:asset_id])
    @property.assets.detach(@asset)
    
    render :update do |page|
      page.replace_html "photo_#{@asset.id}", "<i>Photo has been deleted</i>"
    end
  end
  
  def update_list
    if params[:properties]
      properties = params[:properties]
      if params[:delete]
        for property in properties do
          @property = Property.find(property.to_i)
          begin
            @property.destroy
            flash[:notice] = "Property was deleted"
          rescue Exception => e
            flash[:notice] = e.message
          end
        end
      end
    end
    redirect_to properties_path
  end
  
  def add_comment
    commentable_type = params[:commentable][:commentable]
    commentable_id = params[:commentable][:commentable_id]
    
    @property = Property.find(commentable_id)
    @comment = Comment.new(params[:comment])
    @comment.account_id = current_account.id
    @property.add_comment(@comment)
    
    redirect_to @property
  end
  
  def vote
    vote = Vote.new(:vote => params[:vote], :voteable_id => params[:voteable_id], :voteable_type => params[:voteable_type])
    vote.account_id = current_account.id if current_account
    @property = Property.find(params[:voteable_id])
    @property.votes << vote
    
    render :update do |page|
      page.replace_html 'votes', :partial => 'votes', :object => @property
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.xml
  def destroy
    @property = Property.find(params[:id])
    begin
      @property.destroy
      flash[:notice] = "Property was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(properties_url) }
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
