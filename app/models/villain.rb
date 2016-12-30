class Villain < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name,    presence: true
  has_and_belongs_to_many :conditions
end
