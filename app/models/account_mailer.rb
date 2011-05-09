class AccountMailer < ActionMailer::Base
  
  def signup_notification(account)
    setup_email(account)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://realtyuz.co.cc/activate/#{account.activation_code}"
  end
  
  def activation(account)
    setup_email(account)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://realtyuz.co.cc/"
  end
  
  def forgot_password(account)
    setup_email(account)
    @subject    += 'You have requested to change your password'
    @body[:url]  = "http://realtyuz.co.cc/reset_password/#{account.password_reset_code}" 
  end
  
  def reset_password(account)
    setup_email(account)
    @subject    += 'Your password has been reset.'
  end
  
  def sms(account)
    setup_email(account)
    @subject += 'Testing! Have a good day! Saida.'
  end

  def request_details(account, fname, lname, email, message)
    @recipients  = account.email
    @from        = fname + " " + lname + "<" + email + ">"
    @subject     = "Request More Details"
    @sent_on     = Time.now
    @body[:account] = account
    @body[:message] = message
  end

  def preference(prop, pref, link)
    setup_email(pref.account)
    @subject+= "New property was added"
    @body[:property] = prop
    @body[:preference] = pref
    @body[:link] = link
  end

  protected
    def setup_email(account)
      @recipients  = account.email
      @from        = "saida.temirkhodjaeva@gmail.com"
      @subject     = "Real Estate Trading Company: "
      @sent_on     = Time.now
      @body[:account] = account
    end
end
