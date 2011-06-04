# == Schema Information
# Schema version: 1
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  login                     :string(255)   
#  crypted_password          :string(40)    
#  salt                      :string(40)    
#  created_at                :datetime      
#  updated_at                :datetime      
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#  is_admin                  :boolean(1)    
#  can_send_messages         :boolean(1)    default(TRUE)
#  time_zone                 :string(255)   default("UTC")
#  email_verification        :string(255)   
#  email_verified            :boolean(1)    
#


require 'digest/sha1'
require 'mime/types'

class User < ActiveRecord::Base
  has_one :profile, :dependent => :nullify
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password, :email, :terms_of_service
  attr_protected :is_admin, :can_send_messages
  
  validates_acceptance_of :terms_of_service, :on => :create
  validates_confirmation_of :password, :if => :password_required?
  validates_presence_of :login
  validates_presence_of :password, :if => :password_required?
  validates_presence_of :password_confirmation, :if => :password_required?
  validates_length_of :password_confirmation, :if => :password_required?,:within => 4..40
  validates_length_of :password, :within => 4..40, :if => :password_required?
  validates_length_of :login, :within => 3..7
  validates_uniqueness_of :login, :case_sensitive => false
  validates_format_of :email, :with => /^([^@\s]{1}+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :on => :create, :message=>"Invalid email address."

  before_save :encrypt_password
  validates_captcha unless ENV['RAILS_ENV'] == 'test'
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )



  def before_create
    # return true
    p = Profile.find_by_email @email
    return true if p.blank?
    errors.add(:email, 'address has already been taken.') and return false unless p.user.blank?
  end

  
  def after_create
    p = Profile.find_or_create_by_email @email
    raise 'User found when should be nil' unless p.user.blank?
    # p = Profile.new
    # p.email = @email
    p.is_active=true
    p.user_id = id
    p.save
    # p = Profile.find(:first, :conditions => ["email = ?", @email], :order => 'created_at DESC' )
    AccountMailer.deliver_signup self.reload
  end
  
  def after_destroy
    profile.update_attributes :is_active=>false
  end

  def f
    profile.f
  end

  def can_mail? user
    can_send_messages? && profile.is_active?
  end



  # Authenticates a user by their login name and unencrypted password.
  # Returns the user or nil.
  def self.authenticate(login, password)
    # u = find_by_login(login) # need to get the salt
    # if request.url.index('localhost')
      # u = User.find(:first, :conditions => ['login LIKE ?', login])           
    # else
      u = User.find(:first, :conditions => ['login ILIKE ?', login])           
    # end
    
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_me
    self.remember_token_expires_at = 10.years.from_now
    self.remember_token = UUID.random_create.to_s + '-' + UUID.random_create.to_s if self.remember_token.nil?
    save false
  end
  
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
  
  def forgot_password
    @forgot = true
    self.password = UUID.random_create.to_s[0,8] rescue rand(1000000000)
    self.password_confirmation = password
    encrypt_password
    save!
    self.password
  end
  
  def change_password(current_password, new_password, confirm_password, admin)
    
    if admin != true
      sp = User.encrypt(current_password, self.salt)
      errors.add( :password, "The password you supplied is not the correct password.") and
        return false unless sp == self.crypted_password
      errors.add( :password, "The new password does not match the confirmation password.") and
        return false unless new_password == confirm_password
      errors.add( :password, "The new password may not be blank.") and
        return false if new_password.blank?
    end
    
    self.password = new_password
    self.password_confirmation = confirm_password
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") 
    self.crypted_password = encrypt(new_password)
    save
  end

protected

  # before filter 
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if
      new_record? || @forgot
    self.crypted_password = encrypt(password)
  end
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
end
