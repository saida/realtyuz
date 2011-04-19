# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' #unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  #config.gem 'haml'
  #config.gem "thoughtbot-paperclip", :lib => "paperclip"
  #config.gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
  #config.gem 'justinfrench-formtastic', :lib => 'formtastic', :source => 'http://gems.github.com'
  
  #config.gem 'tiny_mce'
  
  #config.gem 'seer'
  
  #config.gem 'acts_as_commentable'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]  
  
  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  
  config.active_record.observers = :account_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  config.action_mailer.smtp_settings = {
      :enable_starttls_auto => true,
      :address        => 'smtp.gmail.com',
      :port           => 587,
      :authentication => :plain,
      :user_name      => 'saida.temirkhodjaeva@gmail.com',
      :password       => 'eynshteyn65536'
  }
end

require "base64"
require "will_paginate"

ENV['RECAPTCHA_PUBLIC_KEY'] = '6LflT8MSAAAAAGATp32oJ8GbNck-QtdV5AdQ1sIP'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LflT8MSAAAAAD-C1xVRE506ykzU935fW4D2dwkb'

PROPERTIES = {
  'iron_door' => "Iron Door",
  'garage' => 'Garage',
  'repaired' => 'Repaired',
}