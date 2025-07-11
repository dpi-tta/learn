# app/renderers/lesson_copyable_renderer.rb
class Lesson::CopyableRenderer
  def initialize(doc, style_config:)
    @doc = doc
    @style_config = style_config
  end

  def transform!
    @doc.css("pre.copyable").each do |pre|
      wrapper = Nokogiri::XML::Node.new("div", @doc)
      wrapper["data-controller"] = "copy"
      wrapper["class"] = @style_config.copyable_classes[:wrapper]

      button = Nokogiri::XML::Node.new("button", @doc)
      button["type"] = "button"
      button["data-action"] = "click->copy#copy"
      button["data-copy-target"] = "button"
      button["data-copy-default-value"] = @style_config.copyable_labels[:default]
      button["data-copy-copied-value"] = @style_config.copyable_labels[:copied]
      button["class"] = @style_config.copyable_classes[:button]
      button.content = @style_config.copyable_labels[:default]

      pre["data-copy-target"] = "code"
      pre.remove_attribute("class")

      wrapper.add_child(button)
      wrapper.add_child(pre.clone)
      pre.replace(wrapper)
    end
    @doc
  end
end
