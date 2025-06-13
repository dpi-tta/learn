require "octokit"

module Lesson::GithubSyncable
  extend ActiveSupport::Concern

  GITHUB_REPO_URL_REGEX = %r{\Ahttps://github\.com/[\w.-]+/[\w.-]+\z}

  included do
    # TODO: investigate doing this in a job, or manually, instead of on before_save
    before_save :sync_content_from_github, if: -> { github_repository_url.present? }

    validates :github_repository_url, format: {
      with: GITHUB_REPO_URL_REGEX,
      message: "must be a valid GitHub repository URL (e.g. https://github.com/org/repo)"
    }, allow_blank: true

    validates :github_repository_url, uniqueness: { scope: :github_repository_branch, message: "and branch already used for another lesson" }, if: -> { github_repository_url.present? && github_repository_branch.present? }
  end

  def sync_content_from_github
    client = Octokit::Client.new(Rails.application.credentials.dig(:github))

    self.content = client.contents(github_repository_path, path: "content.md", accept: "application/vnd.github.v3.raw")
    rewrite_image_asset_paths
    rewrite_video_asset_paths
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

  def rewrite_image_asset_paths
    raw_base = "https://raw.githubusercontent.com/#{github_repository_path}/#{github_repository_branch}/"

    # Replace image paths like ![](assets/logo.png) or ![alt](assets/image.gif) with full github url
    self.content.gsub!(/!\[([^\]]*)\]\((assets\/[^\)]+)\)/) do
      alt_text = Regexp.last_match(1)
      asset_path = Regexp.last_match(2)
      "![#{alt_text}](#{raw_base}#{asset_path})"
    end
  end

  def rewrite_video_asset_paths
    raw_base = "https://github.com/#{github_repository_path}/raw/refs/heads/#{github_repository_branch}/"

    # Replace <video src="assets/filename.mp4" ...> with full GitHub raw URL
    self.content.gsub!(/<video([^>]*?)src=["'](assets\/[^"']+\.mp4)["'](.*?)>/i) do
      pre_attrs = Regexp.last_match(1)
      asset_path = Regexp.last_match(2)
      post_attrs = Regexp.last_match(3)
      %Q(<video#{pre_attrs}src="#{raw_base}#{asset_path}"#{post_attrs}>)
    end
  end
end
