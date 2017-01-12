class Villain < ApplicationRecord
  include FriendlyId

  scope :newest_first, -> { order(created_at: :desc) }
  scope :sorted_by, -> (sort_option) {
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("villains.created_at #{ direction }")
    when /^name_/
      # Simple sort on the name colums
      order("LOWER(villains.name) #{ direction }")
    when /^user_/
      joins(:user).order("LOWER(users.name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  scope :search_query, -> (query) {
    return nil if query.nil? or query.blank?

    tags, gens, users, query = parse_query(query)
    res = all

    # Search for tags:
    res = res.tagged_with tags unless tags.empty?

    # Clean up and validate the generations passed in:
    gens = gens.map { |gen|
      gen = gen.capitalize
      if self.generations.include? gen
        self.generations[gen.to_sym]
      end
    }.select { |gen|
      !gen.nil?
    }
    res = res.where("generation in (?)", gens) unless gens.empty?

    # Validate users
    users = User.where("LOWER(name) IN (?)", users.map(&:downcase))
    res = res.where(user: users) unless users.empty?

    # Search for the rest, textlike:
    res.where(
      %(
        name ILIKE :query OR
        drive ILIKE :query OR
        moves ILIKE :query OR
        abilities ILIKE :query OR
        description ILIKE :query OR
        real_name ILIKE :query
      ),
      {
        query: "%#{query}%",
      }
    )
  }

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

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
    ]
  )

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc'],
      ['Creation date (newest first)', 'created_at_desc'],
      ['Creation date (oldest first)', 'created_at_asc'],
      ['Creator name (a-z)', 'user_asc'],
      ['Creator name (z-a)', 'user_desc'],
    ]
  end

  private

  def self.tokenize(str)
    str.split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/)
      .select {|s| not s.empty? }
      .map {|s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'')}
  end

  def self.parse_query(query)
    if query.nil?
      [[], [], [], ""]
    else
      words = tokenize(query)

      # Get tags
      tag_prefix = "tag:"
      tags = words.select {
        |word| word.starts_with? tag_prefix
      }.map {
        |word| word.slice(tag_prefix.length..word.length)
      }

      # Get generations:
      gen_prefix = "gen:"
      gens = words.select {
        |word| word.starts_with? gen_prefix
      }.map {
        |word| word.slice(gen_prefix.length..word.length)
      }

      # Get users:
      user_prefix = "user:"
      users = words.select {
        |word| word.starts_with? user_prefix
      }.map {
        |word| word.slice(user_prefix.length..word.length)
      }

      # Get the rest
      the_rest = words.select {
        |word| (
          !word.starts_with?(tag_prefix) and
          !word.starts_with?(gen_prefix) and
          !word.starts_with?(user_prefix)
        )
      }.join(" ")

      [tags, gens, users, the_rest]
    end
  end
end
