class Lesson::TableOfContentsRenderer
  attr_reader :headings

  def initialize(markdown_text)
    @markdown_text = markdown_text
    @headings = extract_headings_from_markdown
  end

  def mobile_html
    return "" if headings.empty?

    <<~HTML
      <div class="d-lg-none mb-3" data-controller="table-of-contents--toggle">
        <button
          class="btn btn-outline-secondary"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#table-of-contents-mobile"
          aria-expanded="false">
          On this page <i class="bi bi-arrows-vertical" data-table-of-contents--toggle-target="icon"></i>
        </button>

        <nav id="table-of-contents-mobile" class="table-of-contents collapse">
          <h2 class="visually-hidden">Table of Contents</h2>
          <ul class="nav flex-column small">
            #{build_list_items}
          </ul>
        </nav>
      </div>
    HTML
  end

  def desktop_html
    return "" if headings.empty?

    <<~HTML
      <nav id="table-of-contents-desktop" class="table-of-contents table-of-contents-desktop d-none d-lg-block position-sticky mt-5" data-controller="table-of-contents--scrollspy">
        <h6 class="text-muted">On this page</h6>
        <ul class="nav flex-column small" data-table-of-contents--scrollspy-target="ul">
          #{build_list_items}
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

  def build_list_items
    headings.map do |h|
      indent = (h[:level] - 2) * 1
      %(<li class="nav-item ps-#{indent}"><a class="nav-link" href="##{h[:id]}">#{h[:text]}</a></li>)
    end.join("\n")
  end
end
