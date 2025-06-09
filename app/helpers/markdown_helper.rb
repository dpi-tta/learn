module MarkdownHelper
    def render_lesson_markdown(text)
    LessonMarkdownRenderer.new(text).render
  end
end
