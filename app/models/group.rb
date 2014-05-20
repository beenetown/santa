class Group < ActiveRecord::Base
  has_many :users, through: :memberships
  has_many :memberships, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :gifts, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: "owner_id", dependent: :destroy

  validates :name, presence: true
  scope :alphabetize, -> { order('name') }
end
