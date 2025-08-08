# app/renderers/lesson_repl_renderer.rb
class Lesson::ReplRenderer
  def initialize(doc, style_config:)
    @doc = doc
    @style_config = style_config
  end

  def transform!
    @doc.css("pre.repl > code").each do |code_node|
      container = build_repl_container(code_node)
      code_node.parent.replace(container)
    end
    @doc
  end

  private

  def build_repl_container(code_node)
    lang = extract_language(code_node["class"]) || "plaintext"
    code_content = code_node.text

    container = Nokogiri::XML::Node.new("div", @doc)
    container["data-controller"] = "repl"
    container["data-repl-language-value"] = lang
    container["class"] = @style_config.repl_classes[:container]

    container.add_child(build_repl_title(code_node["title"])) if code_node["title"].present?
    container.add_child(build_repl_editor(code_content))
    container.add_child(build_repl_actions)
    container.add_child(build_repl_output)
    container
  end

  def build_repl_title(title)
    Nokogiri::XML::Node.new("div", @doc).tap do |div|
      div["class"] = @style_config.repl_classes[:title]
      div.content = title
    end
  end

  def build_repl_editor(code_content)
    id = "editor-#{SecureRandom.hex(4)}"
    wrapper = Nokogiri::XML::Node.new("div", @doc)
    wrapper["class"] = "form-floating mb-2"

    textarea = Nokogiri::XML::Node.new("textarea", @doc)
    textarea["id"] = id
    textarea["placeholder"] = @style_config.repl_labels[:input]
    textarea["data-repl-target"] = "editor"
    textarea["data-action"] = "input->repl#autoResizeEditor"
    textarea["rows"] = "1"
    textarea["class"] = "#{@style_config.repl_classes[:editor]} form-control"
    textarea["spellcheck"] = "false"
    textarea["autocomplete"] = "off"
    textarea.content = code_content

    label = Nokogiri::XML::Node.new("label", @doc)
    label["for"] = id
    label.content = @style_config.repl_labels[:input]

    wrapper.add_child(textarea)
    wrapper.add_child(label)
    wrapper
  end

  def build_repl_output
    id = "output-#{SecureRandom.hex(4)}"
    wrapper = Nokogiri::XML::Node.new("div", @doc)
    wrapper["class"] = "form-floating mb-3"

    iframe = Nokogiri::XML::Node.new("iframe", @doc)
    iframe["id"] = id
    iframe["placeholder"] = @style_config.repl_labels[:output]
    iframe["data-repl-target"] = "output"
    iframe["class"] = "#{@style_config.repl_classes[:output]} form-control"

    label = Nokogiri::XML::Node.new("label", @doc)
    label["for"] = id
    label.content = @style_config.repl_labels[:output]

    wrapper.add_child(iframe)
    wrapper.add_child(label)
    wrapper
  end

  def build_repl_actions
    row = Nokogiri::XML::Node.new("div", @doc)
    row["class"] = @style_config.repl_classes[:action_row]

    %i[run reset].each do |action|
      button = Nokogiri::XML::Node.new("button", @doc)
      button["type"] = "button"
      button["data-repl-target"] = "#{action}Button"
      button["data-action"] = "repl##{action}"
      button["class"] = @style_config.repl_classes[:"#{action}_btn"]
      button.content = action.to_s.capitalize
      row.add_child(button)
    end

    row
  end

  def extract_language(class_attr)
    class_attr.to_s[%r{language-(\w+)}, 1]
  end
end
