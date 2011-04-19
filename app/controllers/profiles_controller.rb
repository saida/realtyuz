class ProfilesController < ApplicationController
  layout "account"
  
  before_filter :login_required, :except => :show
  before_filter :not_logged_in_required, :only => :show
  # Activate action
  def show
    # Uncomment and change paths to have account logged in after activation - not recommended
    #self.current_account = Account.find_and_activate!(params[:id])
    Account.find_and_activate!(params[:id])
    flash[:notice] = "Your profile has been activated! You can now login." 
    redirect_to login_path
  rescue Account::ArgumentError
    flash[:notice] = 'Activation code not found. Please try creating a new profile.'
    redirect_to new_account_path    
  rescue Account::ActivationCodeNotFound
    flash[:notice] = 'Activation code not found. Please try creating a new profile.'
    redirect_to new_account_path
  rescue Account::AlreadyActivated
    flash[:notice] = 'Your profile has already been activated. You can log in below.'
    redirect_to login_path
  end

  def edit
  end

  # Change password action  
  def update
    return unless request.post?
    if Account.authenticate(current_account.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_account.password_confirmation = params[:password_confirmation]
        current_account.password = params[:password]
        if current_account.save
          flash[:notice] = "Password successfully updated."
          redirect_to root_path #profile_url(current_account.login)
        else
          if params[:password].length < 6 || params[:password].length > 20
            flash[:error] = "New password must be between 6 and 20 symbols."            
          else
            flash[:error] = "An error occured, your password was not changed."
          end
          render :action => 'edit'
        end
      else
        flash[:error] = "New password does not match the password confirmation." 
        @old_password = params[:old_password]
        render :action => 'edit'      
      end
    else
      flash[:error] = "Your old password is incorrect."
      render :action => 'edit' 
    end    
  end

end
