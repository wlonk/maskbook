class Villain < ApplicationRecord
  include FriendlyId
  include PgSearch

  pg_search_scope :search_for, against: [
    :name,
    :drive,
    :moves,
    :abilities,
    :description,
    :real_name,
  ]

  scope :all_for, -> (user) {
    if user.nil?
      ret = where(public: true)
    else
      ret = joins(
        %(
        LEFT OUTER JOIN "users_villains"
                     ON "users_villains"."villain_id" = "villains"."id"
        LEFT OUTER JOIN "users"
                     ON "users"."id" = "users_villains"."user_id"
        )
      ).where(
        "villains.public = true OR villains.user_id = ? OR users.id = ?", user.id, user.id
      )
    end
    ret.order(created_at: :desc)
  }
  scope :all_editable_by, -> (user) {
    if user.nil?
      ret = none
    else
      ret = joins(
        %(
        LEFT OUTER JOIN "users_villains"
                     ON "users_villains"."villain_id" = "villains"."id"
        LEFT OUTER JOIN "users"
                     ON "users"."id" = "users_villains"."user_id"
        )
      ).where(
        "villains.user_id = ? OR users.id = ?", user.id, user.id
      )
    end
    ret.order(created_at: :desc)
  }
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
    pos_tags = tags.select { |t| t[:positive] }.map { |t| t[:word] }
    neg_tags = tags.select { |t| !t[:positive] }.map { |t| t[:word] }
    res = res.tagged_with pos_tags unless pos_tags.empty?
    res = res.tagged_with(neg_tags, exclude: true) unless neg_tags.empty?

    # Clean up and validate the generations passed in:
    pos_gens = gens.select { |g| g[:positive] }.map{ |g| gen_to_sym g[:word] }.select { |g| !g.nil? }
    neg_gens = gens.select { |g| !g[:positive] }.map{ |g| gen_to_sym g[:word] }.select { |g| !g.nil? }
    res = res.where("generation IN (?)", pos_gens) unless pos_gens.empty?
    res = res.where("generation NOT IN (?)", neg_gens) unless neg_gens.empty?

    # Validate users
    pos_users = users.select { |u| u[:positive] }.map { |u| u[:word].downcase }
    neg_users = users.select { |u| !u[:positive] }.map { |u| u[:word].downcase }
    pos_users = User.where("LOWER(name) IN (?)", pos_users)
    neg_users = User.where("LOWER(name) IN (?)", neg_users)
    res = res.where(user: pos_users) unless pos_users.empty?
    res = res.where.not(user: neg_users) unless neg_users.empty?

    # Search for the rest, textlike:
    unless query.empty?
      res.search_for query
    else
      res
    end
  }
  scope :stars, -> (query) {
    return nil if query.nil? or query.blank?

    user = User.find(query)
    Villain.where(id: user.favorites.map { |f| f.villain_id })
  }

  friendly_id :name, use: :slugged

  belongs_to :user
  has_and_belongs_to_many :collaborators, class_name: "User"
  has_and_belongs_to_many :conditions
  has_many :favorites
  has_many :affiliations
  has_many :organizations, through: :affiliations

  validates :user_id, presence: true
  validates :name,    presence: true

  enum generation: [ :Gold, :Silver, :Bronze, :Modern ]

  has_attached_file(
    :mugshot,
    styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png",
    s3_protocol: 'https',
  )
  validates_attachment_content_type :mugshot, content_type: /\Aimage\/.*\z/

  acts_as_taggable

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :stars,
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

  def conditions_emoji
    conditions.map {
      |c|
      case c.name
      when "Afraid"
        "<span title='afraid'>😨</span>"
      when "Angry"
        "<span title='angry'>😡</span>"
      when "Guilty"
        "<span title='guilty'>😬</span>"
      when "Hopeless"
        "<span title='hopeless'>😶</span>"
      when "Insecure"
        "<span title='insecure'>😳</span>"
      end
    }.join(" ").html_safe
  end

  def generation_emoji
    case generation.to_sym
    when :Gold
      "<span title='gold'>⭐️</span>".html_safe
    when :Silver
      "<span title='silver'>✨</span>".html_safe
    when :Bronze
      "<span title='bronze'>⚡️</span>".html_safe
    when :Modern
      "<span title='modern'>☁️</span>".html_safe
    end
  end

  private

  def self.tokenize(str)
    str.split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/)
      .select {|s| not s.empty? }
      .map {|s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'')}
  end

  def self.gen_to_sym(gen)
    gen = gen.capitalize
    if self.generations.include? gen
      self.generations[gen.to_sym]
    end
  end
  
  def self.match_prefix(word, prefix)
    word.starts_with? prefix or word.starts_with? "-#{prefix}"
  end

  def self.slice_and_polarize(word, prefix)
    word = word.slice(prefix.length..word.length)
    positive = !word.starts_with?(':')
    unless positive
      word = word.slice(1..word.length)
    end
    {
      word: word,
      positive: positive,
    }
  end

  def self.parse_query(query)
    if query.nil?
      [[], [], [], ""]
    else
      words = tokenize(query)

      # For tags, generations, and users, we use a sleazy side effect of the
      # slicing to distinguish negative and positive filters. Negative ones
      # will have a leading `:`, which we will then interpret into polarity.

      # Get tags
      tag_prefix = "tag:"
      tags = words.select { |word|
        match_prefix(word, tag_prefix)
      }.map { |word|
        slice_and_polarize(word, tag_prefix)
      }

      # Get generations:
      gen_prefix = "gen:"
      gens = words.select { |word|
        match_prefix(word, gen_prefix)
      }.map { |word|
        slice_and_polarize(word, gen_prefix)
      }

      # Get users:
      user_prefix = "user:"
      users = words.select { |word|
        match_prefix(word, user_prefix)
      }.map { |word|
        slice_and_polarize(word, user_prefix)
      }

      # Get the rest
      the_rest = words.select {
        |word| (
          !word.starts_with?(tag_prefix) and
          !word.starts_with?("-#{tag_prefix}") and
          !word.starts_with?(gen_prefix) and
          !word.starts_with?("-#{gen_prefix}") and
          !word.starts_with?(user_prefix) and
          !word.starts_with?("-#{user_prefix}")
        )
      }.join(" ")

      [tags, gens, users, the_rest]
    end
  end
end
