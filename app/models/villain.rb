class Villain < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name,    presence: true
  has_and_belongs_to_many :conditions

  has_attached_file(
    :mugshot,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
  )
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/
end
