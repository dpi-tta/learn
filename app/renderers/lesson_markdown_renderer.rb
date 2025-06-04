class LessonMarkdownRenderer < Redcarpet::Render::HTML
  def header(text, header_level)
    # Generate an ID from the text
    id = text.parameterize

    <<~HTML.chomp
      <h#{header_level} id="#{id}">
        #{text}
        <a class="heading-link" href="##{id}" aria-hidden="true">
          <i class="bi bi-hash"></i>
        </a>
      </h#{header_level}>
    HTML
  end
end
