class Lesson::QuizRenderer
  def initialize(doc)
    @doc = doc
  end

  def transform!
    transform_choose_best!
    transform_free_text!
    transform_choose_all!
  end

  private

  def transform_choose_all!
    @doc.css("ul.choose_all").each do |ul|
      metadata = {
        id: ul["id"],
        title: ul["title"],
        points: ul["points"],
        answer: ul["answer"]
      }.compact

      answers = JSON.parse(metadata[:answer]) rescue []

      # First <li> is the question
      question_li = ul.at_xpath("./li[1]")
      question_text = question_li&.inner_html
      question_li.remove

      container = Nokogiri::XML::Node.new("div", @doc)
      container["class"] = "quiz-question choose-all"
      container["data-controller"] = "quiz"
      container["data-quiz-id"] = metadata[:id]
      container["data-quiz-title"] = metadata[:title]
      container["data-quiz-points"] = metadata[:points]
      container["data-quiz-answer"] = answers.map(&:to_s).to_json

      question_h3 = Nokogiri::XML::Node.new("h3", @doc)
      question_h3.inner_html = question_text
      container.add_child(question_h3)

      # Only process direct <li> children of the top-level <ul>
      ul.xpath("./li").each_with_index do |li, index|
        # Extract any nested <ul><li> as feedback and remove it
        feedback_node = li.at("ul > li")
        li.search("ul").remove # remove the nested ul

        choice = Nokogiri::XML::Node.new("div", @doc)
        choice["class"] = "quiz-choice"
        choice["data-quiz-choice-index"] = (index + 1).to_s
        choice["data-quiz-target"] = "choice"

        choice.inner_html = <<~HTML
          <label data-controller="quiz">
            <input type="checkbox" name="#{metadata[:id]}[]" value="#{index + 1}" class="me-2">
            #{li.inner_html.strip}
          </label>
          #{feedback_node ? "<div class='quiz-feedback'>#{feedback_node.inner_html.strip}</div>" : ""}
        HTML

        container.add_child(choice)
      end

      ul.replace(container)
    end
  end

  def transform_choose_best!
    @doc.css("ul.choose_best").each do |ul|
      metadata = {
        id: ul["id"],
        title: ul["title"],
        points: ul["points"],
        answer: ul["answer"]
      }.compact

      # First <li> is the question prompt
      question_li = ul.at_xpath("./li[1]")
      question_text = question_li&.inner_html
      question_li.remove

      container = Nokogiri::XML::Node.new("div", @doc)
      container["class"] = "quiz-question choose-best"
      container["data-controller"] = "quiz"
      container["data-quiz-id"] = metadata[:id]
      container["data-quiz-title"] = metadata[:title]
      container["data-quiz-points"] = metadata[:points]
      container["data-quiz-answer"] = metadata[:answer]

      question_h3 = Nokogiri::XML::Node.new("h3", @doc)
      question_h3.inner_html = question_text
      container.add_child(question_h3)

      ul.xpath("./li").each_with_index do |li, i|
        choice_text = li.children.find { |n| n.text? || n.name != "ul" }&.text&.strip
        feedback_node = li.at("ul > li")

        label = Nokogiri::XML::Node.new("label", @doc)
        label["class"] = "quiz-choice"
        label["data-quiz-choice-index"] = (i + 1).to_s
        label["data-quiz-target"] = "choice"

        input = Nokogiri::XML::Node.new("input", @doc)
        input["type"] = "radio"
        input["name"] = metadata[:id]
        input["value"] = (i + 1).to_s

        label.add_child(input)
        label.add_child(Nokogiri::HTML::DocumentFragment.parse(" #{choice_text}"))

        if feedback_node
          feedback_div = Nokogiri::XML::Node.new("div", @doc)
          feedback_div["class"] = "quiz-feedback"
          feedback_div.inner_html = feedback_node.inner_html.strip
          label.add_child(feedback_div)
        end

        container.add_child(label)
      end

      ul.replace(container)
    end
  end

  def transform_free_text!
    @doc.css("ul.free_text").each do |ul|
      metadata = {
        id: ul["id"],
        title: ul["title"],
        points: ul["points"],
        placeholder: ul["placeholder"] || "Your answer..."
      }.compact

      question_li = ul.at_css("li")
      next unless question_li

      container = Nokogiri::XML::Node.new("div", @doc)
      container["class"] = "quiz-question free-text"
      container["data-controller"] = "quiz"
      container["data-quiz-id"] = metadata[:id]
      container["data-quiz-title"] = metadata[:title]
      container["data-quiz-points"] = metadata[:points]

      label = Nokogiri::XML::Node.new("label", @doc)
      label["for"] = metadata[:id]
      label["class"] = "h3"
      label.inner_html = question_li.inner_html

      textarea = Nokogiri::XML::Node.new("textarea", @doc)
      textarea["type"] = "text"
      textarea["name"] = metadata[:id]
      textarea["id"] = metadata[:id]
      textarea["placeholder"] = metadata[:placeholder]
      textarea["class"] = "form-control"
      textarea["data-action"] = "blur->quiz#validateFreeText"

      container.add_child(label)
      container.add_child(textarea)

      ul.replace(container)
    end
  end

  def parse_metadata(text)
    {
      id: text[/#(\w+)/, 1],
      title: text[/title="(.*?)"/, 1],
      points: text[/points="(\d+)"/, 1],
      answer: text[/answer="(.*?)"/, 1]
    }.compact
  end
end
