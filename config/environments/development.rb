# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :test

Paperclip.options[:command_path] = "/opt/local/bin"

config.middleware.use "Rack::Bug",
  :password => "beshtasha",
  :secret_key => "G'aniG'ildirakniG'ildiratibTashlabKetdi"

ENV['RECAPTCHA_PUBLIC_KEY'] = '6LflT8MSAAAAAGATp32oJ8GbNck-QtdV5AdQ1sIP'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LflT8MSAAAAAD-C1xVRE506ykzU935fW4D2dwkb'
