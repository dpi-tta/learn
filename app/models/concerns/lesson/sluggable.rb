module Lesson::Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_slug, if: -> { slug.blank? }
    validates :slug, presence: true # TODO: look into uniqueness: true (could conflict w/ branches)
  end

  private

  # NOTE: may need to append branch name to handle conflict
  def assign_slug
    base = if github_repository_path.present? # relies on Lesson::GithubSyncable
      github_repository_path.split("/").last
    elsif title.present?
      title
    else
      SecureRandom.hex(4) # absolute fallback to prevent nil slug
    end

    self.slug = base.parameterize
  end
end
