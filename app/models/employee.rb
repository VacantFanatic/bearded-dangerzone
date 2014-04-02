class Employee < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase 
    self.uid = uid.downcase
    }
  
  
  has_many :Events
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :uid, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :name, :email, :uid
  
  has_secure_password
end
