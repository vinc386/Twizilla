require 'digest'
class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence  => true,
                   :length    => { :maximum => 50 }
  validates :email, :presence     => true,
                    :format       => { :with => email_regex },
                    :uniqueness   => { :case_sensitive => false }
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..60}
                        
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of 
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = self.find_by_email(email)
    #why these following 2 lines can't be swapped?
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password) 
    # "self.password" is the same as "password" here, same as the following
  end
  
  def encrypt(str)
    secured_hash("#{salt}--#{str}")
  end
  
  def make_salt
     secured_hash("#{Time.now.utc}--#{self.password}")
  end
  
  def secured_hash(str)
    Digest::SHA2.hexdigest(str)
  end
end
