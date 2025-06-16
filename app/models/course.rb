class Course < ApplicationRecord
  has_many :course_lessons, -> { order(:position) }, dependent: :destroy
  has_many :lessons, through: :course_lessons
end
