class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #UserNotifier.deliver_signup_notification(user)
  end

  def after_save(user)
    #UserNotifier.deliver_activation(user) #if user.recently_activated?
    #UserNotifier.deliver_forgot_password(user) #if user.recently_forgot_password?
  end
  
end