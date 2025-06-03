class Lesson < ApplicationRecord
  include GithubSyncable

  def to_param
    [ id, title.parameterize ].join("-")
  end
end
