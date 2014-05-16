class User < ActiveRecord::Base
  has_many :groups, through: :memberships
  has_many :memberships, dependent: :destroy

  has_many :invites, dependent: :destroy
  
  has_many :gifts, foreign_key: "gifter_id", dependent: :destroy
  
  has_many :received_gifts, 
            foreign_key: "giftee_id", 
            class_name: "Gift", 
            dependent: :destroy

  has_many :giftees, through: :gifts
  has_many :gifters, through: :gifts

  has_many :auths, dependent: :destroy   

  before_create :create_remember_token
  
  # scope :alphabetize, -> { order('name') }
  
  def self.shared_groups
    self.all
  end

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
      if self.auths.any? { |a| a.provider == 'santa' }
        return self.auths.find_by(provider: 'santa').name
      else
        self.auths.each do |a|
          return a.name unless a.name.blank?
        end
      end
      return "Anon"
    end
  end

  def self.temp_password
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
