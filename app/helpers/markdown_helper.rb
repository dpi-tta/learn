module MarkdownHelper
  def render_markdown(text)
    html = Kramdown::Document.new(
      text,
      auto_ids: true,
      input: "GFM"
    ).to_html

    html.html_safe
  end
end
