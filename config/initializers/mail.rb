# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address        => 'smtp.gmail.com',
  :port           => 587,
  :authentication => :plain,
  :user_name      => 'saida.temirkhodjaeva@gmail.com',
  :password       => 'eynshteyn65536'
}