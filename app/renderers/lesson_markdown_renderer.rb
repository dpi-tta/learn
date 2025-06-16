# NOTE: some classes are tightly coupled to Bootstrap
class LessonMarkdownRenderer
  def initialize(text)
    @text = text
  end

  def render
    html = Kramdown::Document.new(
      @text,
      auto_ids: true,
      input: "GFM"
    ).to_html

    html = add_header_anchors(html)
    html = transform_repl_blocks(html)

    html.html_safe
  end

  private

  def add_header_anchors(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css("h1, h2, h3, h4, h5, h6").each do |node|
      next unless node["id"]
      id = node["id"]

      anchor = Nokogiri::XML::Node.new("a", doc)
      anchor["href"] = "##{id}"
      anchor["class"] = "heading-link"
      anchor["aria-hidden"] = "true"
      anchor.inner_html = '<i class="bi bi-link-45deg"></i>'

      node.add_child(anchor)
    end

    doc.to_html
  end

  def transform_repl_blocks(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css("pre.repl > code").each do |code_node|
      lang = extract_language(code_node["class"]) || "plaintext"
      code_content = code_node.text

      container = Nokogiri::XML::Node.new("div", doc)
      container["data-controller"] = "repl"
      container["data-repl-language-value"] = lang
      container["class"] = "repl-container"

      if (title = code_node["title"]).present?
        title_div = Nokogiri::XML::Node.new("div", doc)
        title_div["class"] = "repl-title"
        title_div.content = title
        container.add_child(title_div)
      end

      iframe = Nokogiri::XML::Node.new("iframe", doc)
      iframe["data-repl-target"] = "output"
      iframe["class"] = "repl-output"
      container.add_child(iframe)

      textarea = Nokogiri::XML::Node.new("textarea", doc)
      textarea["data-repl-target"] = "editor"
      textarea["data-action"] = "input->repl#autoResizeEditor"
      textarea["rows"] = "1"
      textarea["class"] = "repl-editor"
      textarea["spellcheck"] = "false"
      textarea["autocomplete"] = "off"
      textarea.content = code_content
      container.add_child(textarea)

      action_row = Nokogiri::XML::Node.new("div", doc)
      action_row["class"] = "mt-2 d-flex align-items-center"

      run_btn = Nokogiri::XML::Node.new("button", doc)
      run_btn["type"] = "button"
      run_btn["data-action"] = "repl#run"
      run_btn["class"] = "repl-run btn btn-primary btn-sm"
      run_btn.content = "Run"
      action_row.add_child(run_btn)

      reset_btn = Nokogiri::XML::Node.new("button", doc)
      reset_btn["type"] = "button"
      reset_btn["data-action"] = "repl#reset"
      reset_btn["class"] = "repl-reset btn btn-outline-secondary btn-sm ms-2"
      reset_btn.content = "Reset"
      action_row.add_child(reset_btn)

      container.add_child(action_row)
      code_node.parent.replace(container)
    end

    doc.to_html
  end

  def extract_language(class_attr)
    class_attr.to_s[%r{language-(\w+)}, 1]
  end
end
