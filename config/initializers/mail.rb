# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.gmail.com",
  :port => 25,
  :domain => "google.com",
  :authentication => :login,
  :user_name => "saida.temirkhodjaeva@gmail.com",
  :password => "eynshteyn"  
}