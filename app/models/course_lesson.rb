class CourseLesson < ApplicationRecord
  include Positionable

  belongs_to :course
  belongs_to :lesson

  validates :lesson_id, uniqueness: { scope: :course_id }
end
