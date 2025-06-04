require_relative "../config/environment"

require 'octokit'

ORG_NAME = "dpi-tta-lessons"

client = Octokit::Client.new(Rails.application.credentials.dig(:github))
repositories = client.org_repos(ORG_NAME)

repositories.each do |repository|
  github_repository_url = repository.html_url

  if Lesson.exists?(github_repository_url:)
    puts "Skipping existing lesson: #{github_repository_url}"
    next
  end

  lesson = Lesson.create!(github_repository_url:)

  puts "Created lesson: #{lesson.title}"
rescue StandardError => e
  puts "Failed to import #{repo.name}: #{e.message}"
end
