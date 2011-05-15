class Contact < ActiveRecord::Base
  acts_as_taggable
  
  belongs_to :profile
  

  #alias_method :parent, :user
  
    
  validates_presence_of     :callsign
  validates_length_of       :callsign,    :within => 3..8
  validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i

  before_create :make_confirmation_code
  
  
  protected
    # before filter 
    def make_confirmation_code
      self.confirmation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
end
