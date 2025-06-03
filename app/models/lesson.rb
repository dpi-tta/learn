class Lesson < ApplicationRecord
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
