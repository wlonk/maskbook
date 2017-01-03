class Villain < ApplicationRecord
  include FriendlyId

  scope :newest_first, -> { order(created_at: :desc) }

  friendly_id :name, use: :slugged
  belongs_to :user
  validates :user_id, presence: true
  validates :name,    presence: true

  enum generation: [ :Gold, :Silver, :Bronze, :Modern ]

  has_and_belongs_to_many :conditions

  has_attached_file(
    :mugshot,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
  )
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/

  acts_as_taggable

  def self.search(tags, gens, users, query)
    res = all

    # Search for tags:
    if !tags.empty?
      res = res.tagged_with tags
    end

    # Clean up and validate the generations passed in:
    gens = gens.map { |gen|
      gen = gen.capitalize
      if self.generations.include? gen
        self.generations[gen.to_sym]
      end
    }.select { |gen|
      !gen.nil?
    }
    if !gens.empty?
      res = res.where("generation in (?)", gens)
    end

    # Validate users
    users = User.where("LOWER(name) IN (?)", users.map(&:downcase))
    if !users.empty?
      res = res.where(user: users)
    end

    # Search for the rest, textlike:
    res.where(
      "name ILIKE ? OR
      drive ILIKE ? OR
      moves ILIKE ? OR
      abilities ILIKE ? OR
      description ILIKE ? OR
      real_name ILIKE ?",
      "%#{query}%",
      "%#{query}%",
      "%#{query}%",
      "%#{query}%",
      "%#{query}%",
      "%#{query}%",
    )
  end
end
