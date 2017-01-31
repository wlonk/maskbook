class User < ApplicationRecord
  include FriendlyId

  friendly_id :name, use: :slugged
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
  has_many :villains
  has_many :collab_villains, class_name: "Villain"
end
