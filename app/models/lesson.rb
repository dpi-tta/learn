class Lesson < ApplicationRecord
  include GithubSyncable
  include Sluggable

  has_many :course_lessons, dependent: :destroy
  has_many :courses, through: :course_lessons

  # TODO: validate title
  # validates :title, presence: true

  def to_param
    [ id, title.parameterize ].join("-")
  end

  def to_s
    title
  end
end
