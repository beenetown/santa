class Auth < ActiveRecord::Base
  belongs_to :user
  has_secure_password validations: false
  before_save { self.email = email.downcase }
  
  validates :password, length: { minimum: 6 }, unless: :third_party?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  def self.already_linked?(email)
    self.find_by(email: email)
  end
end
