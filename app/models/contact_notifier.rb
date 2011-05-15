class ContactNotifier < ActionMailer::Base
  
  def confirmation(contact)
    if contact.email != nil
      setup_email(contact)
      @subject    += 'Confirm QSL from ' + contact.profile.user.login + '!'
      @body[:url]  = "http://www.73s.org/confirm/#{contact.confirmation_code}" 
    end
  end
  
  
  protected
  def setup_email(contact)
    @recipients  = "#{contact.email}"
    @from        = "admin@73s.org"
    @subject     = "73s.org - "
    @sent_on     = Time.now
    @body[:contact] = contact
  end
end
