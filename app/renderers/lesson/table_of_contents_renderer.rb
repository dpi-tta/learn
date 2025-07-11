class Lesson::TableOfContentsRenderer
  def initialize(markdown_text)
    @markdown_text = markdown_text
  end

  def render
    headings = extract_headings_from_markdown
    return "" if headings.empty?

    table_of_contents_list = build_table_of_contents_list(headings)

    <<~HTML
      <button
        class="btn btn-outline-secondary mb-3"
        type="button"
        data-controller="table-of-contents-toggle"
        data-bs-toggle="collapse"
        data-bs-target="#table-of-contents"
        aria-expanded="false">
        On this page <i class="bi bi-arrows-vertical" data-table-of-contents-toggle-target="icon"></i>
      </button>

      <nav id="table-of-contents" class="table-of-contents collapse">
        <h2 class="visually-hidden">Table of Contents</h2>
        <ul class="nav flex-column small">
          #{table_of_contents_list}
        </ul>
      </nav>
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

  def build_table_of_contents_list(headings)
    headings.map do |h|
      %(<li class="nav-item ms-#{(h[:level] - 2) * 2}"><a class="nav-link" href="##{h[:id]}">#{h[:text]}</a></li>)
    end.join("\n")
  end
end
