class Organization < ApplicationRecord
  include FriendlyId

  friendly_id :name, use: :slugged
  belongs_to :user
  validates :user_id, presence: true
  validates :name,    presence: true
end
