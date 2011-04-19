# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  uses_tiny_mce(
      :options => {:theme => 'advanced',
      :browsers => %w{msie gecko},
      :theme_advanced_toolbar_location => "top",
      :theme_advanced_toolbar_align => "left",
      :theme_advanced_resizing => true,
      :theme_advanced_resize_horizontal => false,
      :paste_auto_cleanup_on_paste => true,
      :theme_advanced_buttons1 => %w{formatselect fontselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright indent outdent separator bullist numlist forecolor backcolor separator link unlink image undo redo},
      :theme_advanced_buttons2 => [],
      :theme_advanced_buttons3 => [],
      :plugins => %w{ contextmenu paste table fullscreen }},
      :only => [:new, :create, :edit, :update])
    
  layout 'admin'
  
  include AuthenticatedSystem
  
  before_filter :login_required
  #before_filter :check_administrator_role, :only => [:edit, :update, :destroy]
  
  session :session_key => '_realestate_session_id'
  
  helper :all # include all helpers, all the time
  protect_from_forgery
  
  # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # Sources of restful authentication is taken from
  # http://railsforum.com/viewtopic.php?pid=74245#p74245
end
