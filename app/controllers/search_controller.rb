class SearchController < ApplicationController
  def search
    tags, query = parse_query(params[:s])
    @villains = Villain
      .search(tags, query)
      .newest_first
      .paginate(page: params[:page])
  end

  private

  def parse_query(query)
    words = query.split(' ')
    tag_prefix = "tag:"
    tags = words.select {
      |word| word.starts_with? tag_prefix
    }.map {
      |word| word.slice(tag_prefix.length..word.length)
    }
    non_tags = words.select { |word| !word.starts_with? "tag:" }.join(" ")
    [tags, non_tags]
  end
end
