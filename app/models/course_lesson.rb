class CourseLesson < ApplicationRecord
  include Positionable

  belongs_to :course
  belongs_to :lesson

  validates :lesson_id, uniqueness: { scope: :course_id }

  def to_s
    "#{course} | #{lesson}"
  end
end
