json.extract! lesson, :id, :title, :content, :github_url, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
