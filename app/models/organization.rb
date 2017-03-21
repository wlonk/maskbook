class Organization < ApplicationRecord
  include FriendlyId

  friendly_id :name, use: :slugged

  belongs_to :user
  has_many :affiliations
  has_many :villains, through: :affiliations

  validates :user_id, presence: true
  validates :name,    presence: true

  scope :all_editable_by, -> (user) {
    if user.nil?
      ret = none
    else
      ret = where(user: user)
    end
    ret.order(created_at: :desc)
  }
end
