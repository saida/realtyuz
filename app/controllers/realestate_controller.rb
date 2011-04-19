class RealestateController < ApplicationController
  layout "realestate"
  skip_before_filter :login_required
  
  def index
    list
    @properties = Property.search([], params[:set1_page], 'created_at DESC')
    find_my_listings
    #@listings = MyListingsProperty.search(['my_listings_id = ?', @my_listings.id], params[:set2_page])
    
    @featured_listings = MyListingsProperty.find(:all, :select =>"property_id", :group =>"property_id HAVING count(property_id) > 0").collect {|f| f.property_id}
    
    @featured_properties = Property.find(:all, :conditions => ['id IN (?)', @featured_listings], :order => 'created_at DESC', :limit => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.js {
        render :update do |page|
          # 'page.replace' will replace full "results" block...works for this example
          # 'page.replace_html' will replace "results" inner html...useful elsewhere
          if params[:set1_page]
            page.replace_html 'search_results', :partial => 'listings', :object => @properties
          elsif params[:set2_page]
            page.replace_html 'my_listings', :partial => 'my_listings', :object => @listings
          end
        end
      }
    end
  end

  def update_cities
    # updates cities and districts based on region selected
    if params[:region_id] and params[:region_id] != '' 
      region = Region.find(params[:region_id])
      cities = region.cities
      districts = region.districts
    else
      cities = City.all
    end
    
    render :update do |page|
      if !region.nil? and !cities.blank?
        if page['cities'].visible
          page.replace_html 'cities', :partial => 'cities', :object => cities
          page.show 'cities'
        else
          page.insert_html :after, 'cities', :partial => 'cities', :object => cities
          page.show 'cities'
        end
      elsif params[:region_id] == ''
        page.hide 'cities'
      end
    end
  end
  
  def update_districts
    # updates districts based on city selected
    if params[:city_id] and params[:city_id] != ''
      city = City.find(params[:city_id])
      districts = city.districts
    else
      districts = nil
    end
    
    render :update do |page|
      if !districts.blank?
        if page['districts'].visible
          page.replace_html 'districts', :partial => 'districts', :object => districts
          page.show 'districts'        
        else
          page.insert_html :after, 'districts', :partial => 'districts', :object => districts
          page.show 'districts'
        end
      else
        page.hide 'districts'
      end
    end
  end
  
  def search_results
    @my_listings = find_my_listings
    
    # check every control whether data is entered or not
      # if entered find the results else pass all values
    
    if params[:category_id] and params[:category_id] != '' then category = Category.find(params[:category_id])
    else category = Category.all
    end
    
    if params[:ptype_id] and params[:ptype_id] != '' then ptype = Ptype.find(params[:ptype_id])
    else ptype = Ptype.all
    end
    
    if params[:room_id] and params[:room_id] != '' then room = Room.find(params[:room_id])
    else room = Room.all
    end
    
    if params[:floor] and params[:floor] != '' then floor = params[:floor]
    else floor = (1..16).to_a
    end
    
    if params[:material_id] and params[:material_id] != '' then material = Material.find(params[:material_id])
    else material = Material.all
    end
    
    if params[:area] and params[:area] != '' then area = params[:area].to_f
    else area = 0
    end
    
    if params[:region_id] and params[:region_id] != '' then region = Region.find(params[:region_id])
    else region = Region.all 
    end
    
    if params[:property] && params[:property][:city_id] and params[:property][:city_id] != '' then city = City.find(params[:property][:city_id])
    else city = City.all
    end

    if params[:property] && params[:property][:city_id] != '' # city is selected
      if !params[:property][:district_id]
        district = nil  # city is selected but district parameter does not exist
      else
        if params[:property] && params[:property][:district_id] == '' # city is selected and district parameter is empty
          if !city.districts.blank? 
            district = city.districts # city is selected and has districts
          else
            district = nil                                    # city is selected but has no districts
          end
        else
          district = District.find(params[:property][:district_id])     # city and district are selected
        end
      end
    else
      if params[:region_id] == ''
        district = [nil, District.all]
      elsif params[:property] && !region.districts.blank?
        district = region.districts
      else
        district = nil
      end
    end
      
    minprice = params[:minprice].to_i
    
    if params[:maxprice] and params[:maxprice] != '' then maxprice = params[:maxprice].to_i
    else maxprice = 999999999
    end
    
    if params[:metro_id] and params[:metro_id] != '' then @metro_properties = Metro.find(params[:metro_id]).properties
    else @metro_properties = Property.all
    end
    
    if params[:school_id] and params[:school_id] != '' then @school_properties = School.find(params[:school_id]).properties
    else @school_properties = Property.all
    end
    
    more_properties = @metro_properties - (@metro_properties - @school_properties)
    
    # retrieve all listing info into @properties array
    
    if params[:property] && params[:property][:district_id] and params[:property][:district_id] != ''
      @properties = Property.search(['id IN (?) AND category_id IN (?) AND ptype_id IN (?) AND room_id IN (?) AND floor IN (?) AND material_id IN (?) AND area >= ? AND region_id IN (?) AND city_id IN (?) AND district_id IN (?) AND price >= ? AND price <= ?', more_properties, category, ptype, room, floor, material, area, region, city, district, minprice, maxprice], params[:set1_page], sort_order('created_at'))
    else
      @properties = Property.search(['id IN (?) AND category_id IN (?) AND ptype_id IN (?) AND room_id IN (?) AND floor IN (?) AND material_id IN (?) AND area >= ? AND region_id IN (?) AND city_id IN (?) AND price >= ? AND price <= ?', more_properties, category, ptype, room, floor, material, area, region, city, minprice, maxprice], params[:set1_page], sort_order('created_at'))
    end
  
    if @properties.empty?
      flash[:notice] = "There is no such property yet"
    end
    
    if request.xhr?
      if !@properties.empty?
        respond_to { |format| format.js }
      else
        render :update do |page|
          page.hide 'search_results'
          page.show 'notice'
          page.replace_html 'notice', "<span>#{flash[:notice]}</span>"
          page["notice"].visual_effect :fade, :duration => 10
          flash[:notice] = nil
        end
      end
    else
      render :partial => 'listings', :object => @properties, :layout => 'realestate'
    end
  end

  def sort_order(default)
    "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
  end

  def add_property
    @property = Property.new
    array_list

    coordinates = [41, 69]
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(coordinates, 14)
  end

  def edit_property
    @property = Property.find(params[:id])
    array_list

    coordinates = [41, 69]
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init(coordinates, 14)
  end

  def delete_property
    @property = Property.find(params[:id])
    @property.destroy
    flash[:notice] = "Property removed!"
    redirect_to "/realestate/my"
  end

  def show_property
    @property = Property.find(params[:id])
    @my_listings = find_my_listings

    unless @property.longitude.nil? || @property.latitude.nil?
      coordinates = [@property.latitude, @property.longitude]
      @map = GMap.new("map")
      @map.control_init(:large_map => true, :map_type => true)
      @map.center_zoom_init(coordinates, 14)
      @map.overlay_init(GMarker.new(coordinates))
    end
    
    @seller = @property.account.user
  end

  def show_photo
    @asset = Asset.find(params[:id])
    
    if request.xhr?
      render :update do |page|
        page.replace_html 'property-photo', "<img src=#{@asset.url(:large)}>"
      end
    else
      redirect_to :action => 'show_property', :id => params[:property_id]
    end
  end
  
  def show_user
    @account = Account.find(params[:id])
    if @account.user
      @user = @account.user
    else
      flash[:notice] = "Sorry! There is no information about the user"
      redirect_to '/'
    end
  end
  
  def show_agency
    @agency = Agency.find(params[:id])
    unless @agency
      flash[:notice] = "Sorry! There is no information about the agency"
      redirect_to '/'
    end
  end

  def show_articles
    @articles = Article.all(:include => [:account, :art_category])
  end
  
  def quick_search
    list
    
    render :update do |page|
      page.replace_html 'advanced_search', :partial => 'search'
    end
  end
  
  def agency_search
    if params[:search_text] and params[:search_text] != ''
      s = params[:search_text].downcase
      
      @regions = Region.find(:all, :conditions => "lower(region_name) like '%#{s}%'")
      @cities = City.find(:all, :conditions => "lower(city_name) like '%#{s}%'")
      @districts = District.find(:all, :conditions => "lower(district_name) like '%#{s}%'")
      
      @agencies = Agency.find(:all, :conditions => ["lower(agency_name) like '%#{s}%' OR lower(phone1) like '%#{s}%' OR lower(phone2) like '%#{s}%' OR lower(email) like '%#{s}%' OR region_id IN (?) OR city_id IN (?) OR district_id IN (?)", @regions, @cities, @districts])
    else
      @agencies = Agency.all
    end
    
    if @agencies.empty?
      flash[:notice] = "There's no matching agency or realtor"
    end
    
    if request.xhr?
      render :update do |page|
        page.hide 'search_results'
        page.hide 'featured_listing'
        page.show 'agency_search_results'
        page.replace_html 'agency_search_results', :partial => 'agency_search_results', :object => @agencies
        if flash[:notice] and flash[:notice] != ''
          page.insert_html :before, 'agency_search_results', "<div id='notice'>#{flash[:notice]}</div>"
          page["notice"].visual_effect :fade, :duration => 6
        end
      end
    else
      render :partial => 'agency_search_results', :object => @agencies, :layout => 'realestate'
    end
  end
  
  def add_comment
    commentable_type = params[:commentable][:commentable]
    commentable_id = params[:commentable][:commentable_id]

    @comment = Comment.new(params[:comment])
    @comment.account_id = current_account.id if current_account
    if commentable_type == "Agency"
      @obj = Agency.find(commentable_id)
      @obj.add_comment(@comment)
    else
      @obj = Property.find(commentable_id)
      @obj.add_comment(@comment)
    end

    if request.xhr?
      render :update do |page|
        page.replace_html 'comments', :partial => 'comments', :object => @obj
        page["comment-textarea"].value = ""
      end
    else
      redirect_to :action => 'show_property', :id => @obj
    end
  end
  
  def delete_comment
    @comment = Comment.find(params[:id])
    id = @comment.id
    @comment.destroy
    
    if request.xhr?
      render :update do |page|
        page["comment_#{id}"].hide
      end
    else
      redirect_to_index
    end
  end
  
  def vote
    vote = Vote.new(:vote => params[:vote], :voteable_id => params[:voteable_id], :voteable_type => params[:voteable_type])
    vote.account_id = current_account.id if current_account
    @property = Property.find(params[:voteable_id])
    @property.votes << vote
    
    if request.xhr?
      render :update do |page|
        page.replace_html 'votes', :partial => 'votes', :object => @property
      end
    else
      redirect_to :action => 'show_property', :id => @property.id
    end
  end

  def send_sms
   AccountMailer.deliver_sms("saida.temirkhodjaeva@gmail.com") # 998933869206@sms.ucell.uz
   render :nothing => true
  end

  def add_to_my_listings
    begin
      params[:property_id].gsub!(/property_/, "")
      @property = Property.find(params[:property_id])
    rescue ActiveRecord::RecordNotFound     # if different property id is entered
      logger.error("Attempt to access invalid property #{params[:id]}")
      redirect_to_index("Invalid property")
    else
      @my_listings = find_my_listings
      @listing = @my_listings.my_listings_properties.find(:first, :conditions => ['property_id = ?', @property.id])
      if !@listing
        @listing = MyListingsProperty.new
        @listing.property_id = @property.id
        @listing.my_listings_id = @my_listings.id
      end
      
      if @listing.save
        @listings = MyListingsProperty.search(['my_listings_id = ?', @my_listings.id], params[:set2_page])
        if request.xhr?
          respond_to { |format| format.js }
        else
          redirect_to_index
        end
      else
        redirect_to_index("Saving the listing was not successful")
      end
    end
  end
  
  def remove_from_my_listings
    @my_listings = MyListings.find(params[:id])
    @property = Property.find(params[:property_id])
    @listing = @my_listings.my_listings_properties.find(:first, :conditions => ['property_id = ?', @property.id])
    @listing.destroy
    flash[:notice] = "Listing has been removed"
    if request.xhr?
      render :update do |page|
        page.select("#listing_#{@property.id}").each do |e| e.hide end
        page.select("#save-img_#{@property.id}").each do |e|
          e.show
        end
        if @my_listings.my_listings_properties.empty?
          @my_listings.destroy
          page["my_listings"].hide
        end
        #page.insert_html :before, 'listings', "<div id='notice'>#{flash[:notice]}</div>"
        #page["notice"].visual_effect :fade, :duration => 4
      end
    else
      redirect_to_index
    end
  end
  
  def clear_my_listings
    if session[:my_listings_id]
      @my_listings = MyListings.find(:first, :conditions => ['id = ?', session[:my_listings_id]])
      session[:my_listings_id] = nil
      @my_listings.my_listings_properties.each do |listing|
        listing.destroy
      end
      @my_listings.destroy
    end
    flash[:notice] = "You have no saved listings"
    if request.xhr?
      render :update do |page|
        page.hide 'my_listings'
        #page.insert_html :before, 'search_results', "<div id='notice'>#{flash[:notice]}</div>"
        page["notice"].visual_effect :fade, :duration => 4
      end
    else
      redirect_to_index
    end
  end
  
  def find_my_listings
    @my_listings = current_account.my_listings if current_account
    @my_listings = MyListings.find(:first, :conditions => ['id = ?', session[:my_listings_id]]) if !@my_listings && session[:my_listings_id]
    if !@my_listings
      @my_listings = MyListings.new
      if current_account and !current_account.my_listings
        @my_listings.account_id = current_account.id
      end
      @my_listings.save!
    end
    
    @my_listings_properties = MyListingsProperty.search(['my_listings_id = ?', @my_listings.id], params[:set2_page])
    
    session[:my_listings_id] = @my_listings
    
    if @my_listings.save
      @my_listings
    else
      render 'index'
    end
  end
  
  def list
    @categories = Category.all
    @ptypes = Ptype.all
    @rooms = Room.all
    @regions = Region.all
    @cities = City.all
    @districts = District.all
    @metros = Metro.all
    @schools = School.all
    @materials = Material.all
  end
  
  def array_list
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

  def my
    @properties = current_account.properties
  end

  def request_details
    @property = Property.find(params[:id])
    if params[:lname] && params[:fname]
      AccountMailer.deliver_request_details(@property.account, params[:fname], params[:lname], params[:email], params[:message])
      #render :action => "request_details_sent"
      render :update do |page|
        page.replace_html :request_details_container, "Message has been sent successfully!"
      end
    else
      render :action => "request_details", :layout => "account"
    end
  end

private
   def redirect_to_index(msg = nil)
     flash[:notice] = msg if msg
     redirect_to :action => :index
   end
end
