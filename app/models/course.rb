class Course < ApplicationRecord
  has_many :course_lessons, -> { order(:position) }, dependent: :destroy
  has_many :lessons, through: :course_lessons

  def to_param
    [ id, title.parameterize ].join("-")
  end

  def to_s
    title
  end
end
