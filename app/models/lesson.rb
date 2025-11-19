class Lesson < ApplicationRecord
  include GithubSyncable
  include Sluggable

  has_many :course_lessons, dependent: :destroy
  has_many :courses, through: :course_lessons

  # TODO: validate title
  # validates :title, presence: true

  # TODO: change to ILIKE when moving to postgres
  scope :search_by_title, ->(query) { where("title LIKE ?", "%#{query}%") }

  def to_param
    [ id, title.parameterize ].join("-")
  end

  def to_s
    title
  end
end
