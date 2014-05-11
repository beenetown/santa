class User < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_many :invites, dependent: :destroy
  # has_secure_password validations: false
  
  has_many :gifts, foreign_key: "gifter_id", dependent: :destroy
  
  has_many :received_gifts, 
            foreign_key: "giftee_id", 
            class_name: "Gift", 
            dependent: :destroy

  has_many :giftees, through: :gifts
  has_many :gifters, through: :gifts

  # has_many :received_gifts,

  has_many :auths, dependent: :destroy   

  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, presence: true, 
  #                   format: { with: VALID_EMAIL_REGEX }, 
  #                   uniqueness: { case_sensitive: false }

  # validates :password, length: { minimum: 6 }                    

  
  before_create :create_remember_token

  # scope :alphabetize, -> { order('view_name') }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def view_name
    if self.guest? 
      "Guest" 
    else 
      self.auths.each do |a|
        return a.name unless a.name.blank?
      end
      "Anon"
    end
  end

  def User.temp_password
    SecureRandom.urlsafe_base64
  end

  def self.destroy_old_guests
    where(guest: true).where("created_at < ?", 1.week.ago).destroy_all
    puts "=============================================="
    puts "Old Guests completed #{Time.now.strftime('on %m/%d/%Y at %I:%M%p')}."
    puts "=============================================="
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
