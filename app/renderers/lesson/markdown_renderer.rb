class Lesson::MarkdownRenderer
  def initialize(text, style_config: Lesson::StyleConfig)
    @text = text
    @style_config = style_config
  end

  def render
    html = Kramdown::Document.new(
      @text,
      auto_ids: true,
      input: "GFM"
    ).to_html

    doc = Nokogiri::HTML::DocumentFragment.parse(html)

    inject_mobile_table_of_contents(doc)
    add_header_anchors(doc)
    stylize_lead_paragraph(doc)

    Lesson::ReplRenderer.new(doc, style_config: @style_config).transform!
    Lesson::CopyableRenderer.new(doc, style_config: @style_config).transform!
    Lesson::QuizRenderer.new(doc).transform!

    doc.to_html.html_safe
  end

  private

  def add_header_anchors(doc)
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

  def inject_mobile_table_of_contents(doc)
    mobile_html = Lesson::TableOfContentsRenderer.new(@text).mobile_html
    return if mobile_html.blank?

    first_h2 = doc.at_css("h2")
    if first_h2
      first_h2.add_previous_sibling(mobile_html)
    else
      doc.children.first.add_previous_sibling(mobile_html)
    end
  end

  def stylize_lead_paragraph(doc)
    lead_class = @style_config.lead_paragraph_class
    return unless lead_class

    h1 = doc.at_css("h1")
    return unless h1

    node = h1.next_element
    if node&.name == "p"
      node["class"] = [ node["class"], lead_class ].compact.join(" ")
    end
  end
end
