require "test_helper"

class Lesson::TableOfContentsRendererTest < ActiveSupport::TestCase
  test "escapes heading text in desktop table of contents" do
    html = Lesson::TableOfContentsRenderer.new('## A & "heading"').desktop_html

    assert_includes html, "A &amp; &quot;heading&quot;"
    refute_includes html, 'A & "heading"'
  end
end
