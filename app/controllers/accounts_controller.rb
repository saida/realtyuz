class AccountsController < ApplicationController
  skip_before_filter :login_required
  layout :set_layout
  
  protect_from_forgery :except => [:create, :update, :delete]
  # Protect these actions behind an admin login
  skip_before_filter :login_required, :only => [:new, :create]
  #before_filter :login_required, :only => [:show, :edit, :update]
  #before_filter :check_administrator_role, :only => [:index, :destroy, :enable, :suspend, :unsuspend, :destroy, :purge]
  #before_filter :find_account, :only => [:suspend, :unsuspend, :destroy, :purge]
  
  def set_layout
    params[:action] == 'index' ? 'admin' : (params[:layout] || 'realestate')
  end
  
  def index
   @accounts = Account.all
   
   render :text => @accounts.to_json
  end
  
  #These show, edit, update actions only allow users to view and update their own profile
  def show
    @account = current_account
  end
  
  # render new.rhtml
  def new
    @account = Account.new
    @user = User.new
    if params[:type] == 'ind'
    elsif params[:type] == 'agent'
      @agencies = Agency.all.collect {|a| [a.agency_name, a.id]}
      @agency = Agency.new
      @utypes = Utype.find(:all, :conditions => ['usertype = ? OR usertype = ?', 'agent', 'broker']).collect {|ut| [ut.usertype, ut.id] }
      @brokers = User.find(:all, :conditions => ['utype_id = ? OR utype_id = ?', 3, 4]).collect {|b| [b.fname + " " + b.lname, b.id]}
    end
  end
 
  def create
    logout_keeping_session!
    require 'net/http'
    @account = Account.new(params[:account])

    @user = User.new(params[:account][:user])
    @user.email = params[:account][:email]
    @user.save if @user.valid?
    @account.user_id = @user.id
    @account.register! if @account && @account.valid? && @user.valid?
    success = @user && @account && @account.valid? && @user.valid?
    correct_captcha = verify_recaptcha(@account) 
    if success && @account.errors.empty? && @user.save && correct_captcha
      if params[:type] == 'ind'
        @account.user.utype.id = 5
      end
      self.current_account = @account
      flash[:notice] = "Thanks for signing up! We're sending you an email with your activation code."
      redirect_back_or_default('/')
    elsif !correct_captcha
      flash[:error] = "Please reenter the text provided in the image"
      render :action => 'new'
    else
      flash[:error]  = "We couldn't set up that account, sorry. Please try again, or contact an admin."
      render :action => 'new'
    end
  end
  
  def edit
    @account = current_account
  end

  def update
    @account = Account.find(current_account)
    if @account.update_attributes(params[:account])
      flash[:notice] = "Account has been updated"
      if params[:layout]
        redirect_to :controller => 'admin', :action => 'index'
      else
        redirect_back_or_default('/')
      end
    else
      render :action => 'edit'
    end
  end
  
  def activate
    logout_keeping_session!
    account = Account.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && account && !account.active?
        account.activate!
        flash[:notice] = "Signup complete! Please sign in to continue."
        redirect_to '/login'
      when params[:activation_code].blank?
        flash[:error] = "The activation code was missing.  Please follow the URL from your email."
        redirect_back_or_default('/')
      else 
        flash[:error]  = "We couldn't find a account with that activation code -- check your email? Or maybe you've already activated -- try signing in."
        redirect_back_or_default('/')
    end
  end

  def suspend
    @account.suspend! 
    redirect_to accounts_path
  end

  def unsuspend
    @account.unsuspend! 
    redirect_to accounts_path
  end
  
  def purge
    @account.destroy
    redirect_to accounts_path
  end
  
  def destroy
    @account.delete!
    redirect_to accounts_path
  end

  def enable_account
    find_account
    if @account.update_attribute(:enabled, 1)
      flash[:notice] = "Account enabled"
    else
      flash[:error] = "There was a problem enabling this account."
    end
    redirect_to :action => 'index'
  end

  def disable_account
    find_account
    if @account.update_attribute(:enabled, 0)
      flash[:notice] = "Account disabled"
    else
      flash[:error] = "There was a problem disabling this account."
    end
    redirect_to :action => 'index'
  end  
  
  # There's no page here to update or destroy a account.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_account
    @account = Account.find(params[:id])
  end
end
