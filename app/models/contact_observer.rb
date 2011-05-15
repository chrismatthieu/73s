class ContactObserver < ActiveRecord::Observer

  def after_create(contact)
    ContactNotifier.deliver_confirmation(contact)
  end

end