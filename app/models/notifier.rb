class Notifier < ActionMailer::Base
  
  def email_user( toemailaddress, fromemailaddress, esubject, message )
    # Email header info MUST be added here
    @subject = esubject
    @recipients = toemailaddress 
    @from = fromemailaddress
    @body = message

    # Email body substitutions go here
    #@body[“user_id”] = userid
    #@body[“message”] = message
  end
  
end
