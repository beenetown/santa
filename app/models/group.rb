class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :invites, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: "owner_id", dependent: :destroy

  scope :alphabetize, -> { order('name') }
end
