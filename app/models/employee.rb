class Employee < ActiveRecord::Base
  has_many :events, dependent: :destroy
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase}
  before_save {self.userid = userid.downcase}
  before_create :create_remember_token
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :userid, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }


  #attribute accessors overrride the parent att_accessor DON'T use them it will pass validation and write Nil to the DB
  
  has_secure_password
  
  def Employee.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Employee.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Employee.hash(Employee.new_remember_token)
    end
  
end
