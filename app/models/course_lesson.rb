class CourseLesson < ApplicationRecord
  belongs_to :course
  belongs_to :lesson

  # TODO: integrate position
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :lesson_id, uniqueness: { scope: :course_id }

  scope :ordered, -> { order(:position) }

  before_validation :assign_position, on: :create

  private

  def assign_position
    return if position.present?
    self.position = course.course_lessons.maximum(:position).to_i + 1 if course
  end
end
