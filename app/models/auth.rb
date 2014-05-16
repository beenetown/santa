class Auth < ActiveRecord::Base
  belongs_to :user
  has_secure_password validations: false
  before_save { self.email = email.downcase }
  
  validates :password, length: { minimum: 6 }, unless: :third_party?
  validates :password, presence: true, unless: :third_party?
  validates :password, confirmation: true, unless: :third_party?
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  def self.already_linked?(email)
    self.exists?(email: email)
  end
end