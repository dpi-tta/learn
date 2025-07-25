class Lesson < ApplicationRecord
  include GithubSyncable
  include Sluggable

  has_many :course_lessons, dependent: :destroy
  has_many :courses, through: :course_lessons

  # TODO: validate title
  # validates :title, presence: true

  scope :search_by_title, ->(query) { where("title ILIKE ?", "%#{query}%") }

  def to_param
    [ id, title.parameterize ].join("-")
  end

  def to_s
    title
  end
end
