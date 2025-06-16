class LessonStyleConfig
  def self.heading_classes
    {
      "h1" => "display-1 mt-5",
      "h2" => "display-2 mt-5",
      "h3" => "display-4 mt-5",
      "h4" => "mb-2",
      "h5" => "mb-1",
      "h6" => "mb-1"
    }
  end

  def self.heading_link_class
    "heading-link"
  end

  def self.heading_link_icon
    '<i class="bi bi-link-45deg"></i>'
  end

  def self.repl_classes
    {
      container:   "repl-container",
      title:       "repl-title",
      output:      "repl-output",
      editor:      "repl-editor",
      action_row:  "mt-3 d-flex align-items-center justify-content-between",
      run_btn:     "repl-run btn btn-primary px-5",
      reset_btn:   "repl-reset btn btn-link text-black ms-2"
    }
  end

  def self.repl_labels
    {
      input: "Input",
      output: "Output"
    }
  end
end
