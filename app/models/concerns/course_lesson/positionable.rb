module CourseLesson::Positionable
  extend ActiveSupport::Concern

  included do
    # TODO: integrate position
    validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

    scope :ordered, -> { order(:position) }

    before_validation :assign_position, on: :create
  end

  private

  def assign_position
    return if position.present?
    self.position = course.course_lessons.maximum(:position).to_i + 1 if course
  end
end
