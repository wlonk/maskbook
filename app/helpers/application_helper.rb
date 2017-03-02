module ApplicationHelper
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def quote_if_needed(s)
    if s.include? " "
      "\"#{s}\""
    else
      s
    end
  end

  def favorite_button_classes(villain, user)
    if user.nil?
      cls = "disabled"
    elsif Favorite.exists?(villain: villain, user: user)
      cls = "active"
    else
      cls = ""
    end

    if cls.empty?
      "btn btn-default"
    else
      "btn btn-default #{cls}"
    end
  end
end
