class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://www.73s.org/account/activate/" #"#{#user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.73s.org/"
  end
  
  def forgot_password(user)
      setup_email(user)
      @subject    += 'Request to change your password'
      @body[:url]  = "http://www.73s.org/reset_password/" #"#{user.password_reset_code}" 
  end
  
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "admin@73s.org"
    @subject     = "73s.org - "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
