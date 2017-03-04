class User < ApplicationRecord
  include FriendlyId

  friendly_id :name, use: :slugged
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :omniauthable,
    :omniauth_providers => [
      :twitter,
      :google_oauth2,
    ]
  )
  validates :name, presence: true
  has_many :villains
  has_many :collab_villains, class_name: "Villain"
  has_many :favorites
  has_many :organizations

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
end
