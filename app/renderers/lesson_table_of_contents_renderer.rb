class LessonTableOfContentsRenderer
  def initialize(markdown_text)
    @markdown_text = markdown_text
  end

  def render
    headings = extract_headings_from_markdown
    return "" if headings.empty?

    toc_list = build_toc_list(headings)

    <<~HTML
      <button
        class="btn btn-outline-secondary mb-3"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#table-of-contents"
        aria-expanded="false">
        On this page <i class="bi bi-arrows-vertical"></i>
      </button>

      <div id="table-of-contents" class="collapse border rounded bg-light p-4">
        <nav class="toc" data-controller="toc" data-toc-content-value="#lesson">
          <ul class="nav flex-column small">
            #{toc_list}
          </ul>
        </nav>
      </div>
    HTML
  end

  private

  def extract_headings_from_markdown
    html = Kramdown::Document.new(@markdown_text, input: "GFM", auto_ids: true).to_html
    doc = Nokogiri::HTML::DocumentFragment.parse(html)
    doc.css("h2, h3, h4, h5, h6").map do |node|
      { level: node.name[1].to_i, id: node["id"], text: node.text } if node["id"].present?
    end.compact
  end

  def build_toc_list(headings)
    headings.map do |h|
      %(<li class="nav-item ms-#{(h[:level] - 2) * 2}"><a class="nav-link p-0" href="##{h[:id]}">#{h[:text]}</a></li>)
    end.join("\n")
  end
end
