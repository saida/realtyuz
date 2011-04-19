# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'realestate'
  
  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]

  def new
  end

  def create
    password_authentication(params[:login], params[:password])
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected  
  def password_authentication(login, password)
    account = Account.authenticate(login, password)
    if account == nil 
      failed_login("Invalid login or password")
    #elsif account.activated_at.blank?   
    #  failed_login("Your account is not active, please check your email for the activation code.")
    elsif account.enabled == false
      failed_login("Your account has been disabled.")
    else
      self.current_account = account
      successful_login
    end
  end

private
  # Track failed login attempts
  def failed_login(message)
    flash.now[:error] = message
    if request.xhr?
      render :update do |page|
        page.replace 'error', "<div id='error'>#{flash[:error]}</div>"
        page["notice"].hide
      end
    else
      render :new
    end
  end

  def successful_login
    if params[:remember_me] == "1"
      self.current_account.remember_me
      cookies[:auth_token] = { :value => self.current_account.remember_token, :expires => self.current_account.remember_token_expires_at }
    end
    flash[:notice] = "Logged in successfully"
    return_to = session[:return_to]
    if return_to.nil?
      #redirect_to :controller => 'realestate'
    else
      #redirect_to return_to
    end
    if request.xhr?
      render :update do |page|
        page << "self.location='" + (return_to.nil? ? "/" : redirect_to) + "'"
      end
    else
      if return_to.nil?
        redirect_to :controller => 'realestate'
      else
        redirect_to return_to
      end
    end
  end
end
