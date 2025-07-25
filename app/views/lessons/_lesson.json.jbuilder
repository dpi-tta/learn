json.extract! lesson, :id, :title, :description, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
