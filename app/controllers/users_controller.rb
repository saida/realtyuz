class UsersController < ApplicationController
  skip_before_filter :login_required
  layout :set_layout
  
  def set_layout
    params[:layout] || 'admin'
  end
  
  skip_before_filter :login_required
  # GET /users
  # GET /users.xml
  
  def index
    @users = User.find(:all, :order => :email)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    get_list
    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    get_list
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    get_list

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.fname} #{@user.lname} was successfully created."
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    get_list

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.fname} #{@user.lname} was successfully updated."
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def change_photo
    @user = User.find(params[:id])
    
    render :update do |page|
      page.insert_html :after, 'change_photo', :partial => 'change_photo', :object => @user
      page.hide 'link_to_change'
    end
  end
  
  def update_list
    if params[:users]
      users = params[:users]
      if params[:delete]
        for user in users
          @user = User.find(user.to_i)
          begin
            @user.destroy
            flash[:notice] = "User was deleted"
          rescue Exception => e
            flash[:notice] = e.message
          end
        end
      end
    end
    
    redirect_to users_path
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flash[:notice] = "User was deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_list
    @utypes = Utype.all.collect {|ut| [ut.usertype, ut.id] }
    @agencies = Agency.all.collect {|a| [a.agency_name, a.id]}
    @brokers = User.find(:all, :conditions => ['utype_id = ? OR utype_id = ?', 3, 4]).collect {|b| [b.fname + " " + b.lname, b.id]}
    @layout = params[:layout]
  end
end
