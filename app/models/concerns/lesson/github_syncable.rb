module Lesson::GithubSyncable
  extend ActiveSupport::Concern

  included do
    # TODO: investigate doing this in a job, or manually, instead of on create/update
    before_validation :sync_content_from_github, on: [ :create, :update ], if: -> { github_repository_url.present? }
  end

  def sync_content_from_github
    client = Octokit::Client.new(Rails.application.credentials.dig(:github))

    self.content = client.contents(github_repository_path, path: "content.md", accept: "application/vnd.github.v3.raw")
    rewrite_asset_paths
    self.title = extract_title_from_content
    self.description = extract_description_from_content

    Rails.logger.info("GitHub API rate limit remaining: #{client.rate_limit.remaining}")
  rescue Octokit::NotFound
    raise "content.md not found in #{github_repository_url}"
  rescue Octokit::Unauthorized
    raise "Unauthorized access to #{github_repository_url}. Check your token."
  rescue StandardError => e
    raise "GitHub sync failed: #{e.message}"
  end

  private

  def github_repository_path
    nil unless github_repository_url.present?

    github_repository_url.gsub("https://github.com/", "")
  end

  def extract_title_from_content
    # Match the first Markdown H1 (starting with a single # followed by a space)
    match = content.match(/^# (.+)$/)
    match ? match[1].strip : nil
  end

  def extract_description_from_content
    lines = content.lines

    # Find first H1
    h1_index = lines.find_index { |line| line.match(/^# (.+)$/) }
    return nil unless h1_index

    # Grab the lines after the H1
    rest = lines[(h1_index + 1)..]

    # Stop at the next heading (## or deeper)
    description_lines = []
    rest.each do |line|
      break if line.match(/^#{'##'} /) # matches ## or more
      description_lines << line
    end

    description_lines.join.strip
  end

  def rewrite_asset_paths
    raw_base = "https://raw.githubusercontent.com/#{github_repository_path}/#{github_repository_branch}/"

    # Replace image paths like ![](assets/logo.png) or ![alt](assets/image.gif) with full github url
    self.content.gsub!(/!\[([^\]]*)\]\((assets\/[^\)]+)\)/) do
      alt_text = Regexp.last_match(1)
      asset_path = Regexp.last_match(2)
      "![#{alt_text}](#{raw_base}#{asset_path})"
    end
  end
end
