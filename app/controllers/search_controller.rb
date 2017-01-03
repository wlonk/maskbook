class SearchController < ApplicationController
  def search
    tags, gens, users, query = parse_query(params[:s])
    @villains = Villain
      .search(tags, gens, users, query)
      .newest_first
      .paginate(page: params[:page])
  end

  private

  def parse_query(query)
    if query.nil?
      [[], [], [], ""]
    else
      words = query.split(' ')

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
        |word| !word.starts_with?(tag_prefix) && !word.starts_with?(gen_prefix) && !word.starts_with?(user_prefix)
      }.join(" ")
      [tags, gens, users, the_rest]
    end
  end
end
