module MarkdownHelper
  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(text).html_safe
  end

  def render_lesson_markdown(text)
    renderer = LessonMarkdownRenderer.new(with_toc_data: true)
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      fenced_code_blocks: true,
      tables: true
    )
    markdown.render(text).html_safe
  end
end
