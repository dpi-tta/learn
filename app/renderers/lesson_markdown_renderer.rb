class LessonMarkdownRenderer
  def initialize(text, style_config: LessonStyleConfig)
    @text = text
    @style_config = style_config
  end

  def render
    html = Kramdown::Document.new(
      @text,
      auto_ids: true,
      input: "GFM"
    ).to_html

    html = add_header_anchors(html)
    html = transform_repl_blocks(html)
    html = transform_copyable_blocks(html)

    html.html_safe
  end

  private

  def add_header_anchors(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css("h1, h2, h3, h4, h5, h6").each do |node|
      next unless node["id"]
      id = node["id"]

      # Merge heading class from config
      heading_class = @style_config.heading_classes[node.name]
      node["class"] = [ node["class"], heading_class ].compact.join(" ")

      anchor = Nokogiri::XML::Node.new("a", doc)
      anchor["href"] = "##{id}"
      anchor["class"] = @style_config.heading_link_class
      anchor["aria-hidden"] = "true"
      anchor.inner_html = @style_config.heading_link_icon

      node.add_child(anchor)
    end

    doc.to_html
  end

  def transform_repl_blocks(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css("pre.repl > code").each do |code_node|
      container = build_repl_container(doc, code_node)
      code_node.parent.replace(container)
    end

    doc.to_html
  end

  def build_repl_container(doc, code_node)
    lang = extract_language(code_node["class"]) || "plaintext"
    code_content = code_node.text

    container = Nokogiri::XML::Node.new("div", doc)
    container["data-controller"] = "repl"
    container["data-repl-language-value"] = lang
    container["class"] = @style_config.repl_classes[:container]

    container.add_child(build_repl_title(doc, code_node["title"])) if code_node["title"].present?
    container.add_child(build_repl_editor(doc, code_content))
    container.add_child(build_repl_actions(doc))
    container.add_child(build_repl_output(doc))

    container
  end

  def build_repl_title(doc, title)
    title_div = Nokogiri::XML::Node.new("div", doc)
    title_div["class"] = @style_config.repl_classes[:title]
    title_div.content = title
    title_div
  end

  def build_repl_editor(doc, code_content)
    id = "editor-#{SecureRandom.hex(4)}"
    wrapper = Nokogiri::XML::Node.new("div", doc)
    wrapper["class"] = "form-floating mb-2"

    textarea = Nokogiri::XML::Node.new("textarea", doc)
    textarea["id"] = id
    textarea["placeholder"] = @style_config.repl_labels[:input]
    textarea["data-repl-target"] = "editor"
    textarea["data-action"] = "input->repl#autoResizeEditor"
    textarea["rows"] = "1"
    textarea["class"] = "#{@style_config.repl_classes[:editor]} form-control"
    textarea["spellcheck"] = "false"
    textarea["autocomplete"] = "off"
    textarea.content = code_content

    label = Nokogiri::XML::Node.new("label", doc)
    label["for"] = id
    label.content = @style_config.repl_labels[:input]

    wrapper.add_child(textarea)
    wrapper.add_child(label)
    wrapper
  end

  def build_repl_output(doc)
    id = "output-#{SecureRandom.hex(4)}"
    wrapper = Nokogiri::XML::Node.new("div", doc)
    wrapper["class"] = "form-floating mb-3"

    iframe = Nokogiri::XML::Node.new("iframe", doc)
    iframe["id"] = id
    iframe["placeholder"] = @style_config.repl_labels[:output]
    iframe["data-repl-target"] = "output"
    iframe["class"] = "#{@style_config.repl_classes[:output]} form-control"

    label = Nokogiri::XML::Node.new("label", doc)
    label["for"] = id
    label.content = @style_config.repl_labels[:output]

    wrapper.add_child(iframe)
    wrapper.add_child(label)
    wrapper
  end

  def build_repl_actions(doc)
    row = Nokogiri::XML::Node.new("div", doc)
    row["class"] = @style_config.repl_classes[:action_row]

    run_btn = Nokogiri::XML::Node.new("button", doc)
    run_btn["type"] = "button"
    run_btn["data-action"] = "repl#run"
    run_btn["class"] = @style_config.repl_classes[:run_btn]
    run_btn.content = "Run"

    reset_btn = Nokogiri::XML::Node.new("button", doc)
    reset_btn["type"] = "button"
    reset_btn["data-action"] = "repl#reset"
    reset_btn["class"] = @style_config.repl_classes[:reset_btn]
    reset_btn.content = "Reset"

    row.add_child(run_btn)
    row.add_child(reset_btn)
    row
  end

  def transform_copyable_blocks(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    doc.css("pre.copyable").each do |pre|
      wrapper = Nokogiri::XML::Node.new("div", doc)
      wrapper["data-controller"] = "copy"
      wrapper["class"] = @style_config.copyable_classes[:wrapper]

      # Copy button
      button = Nokogiri::XML::Node.new("button", doc)
      labels = @style_config.copyable_labels
      button["data-copy-target"] = "button"
      button["data-copy-default-value"] = labels[:default]
      button["data-copy-copied-value"] = labels[:copied]
      button["type"] = "button"
      button["data-action"] = "click->copy#copy"
      button["class"] = @style_config.copyable_classes[:button]
      button.content = labels[:default]

      pre["data-copy-target"] = "code"
      pre.remove_attribute("class")

      wrapper.add_child(button)
      wrapper.add_child(pre.clone)
      pre.replace(wrapper)
    end

    doc.to_html
  end


  def extract_language(class_attr)
    class_attr.to_s[%r{language-(\w+)}, 1]
  end
end
