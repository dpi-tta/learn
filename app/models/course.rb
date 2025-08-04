class Course < ApplicationRecord
  include Positionable

  has_many :course_lessons, -> { order(:position) }, dependent: :destroy
  has_many :lessons, through: :course_lessons

  accepts_nested_attributes_for :course_lessons, allow_destroy: true

  def to_param
    [ id, title.parameterize ].join("-")
  end

  def to_s
    title
  end
end
