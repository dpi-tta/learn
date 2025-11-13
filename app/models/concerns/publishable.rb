module Publishable
  extend ActiveSupport::Concern

  included do
    attr_accessor :published
    before_validation :apply_published_flag
    scope :published, -> { where("published_at <= ?", Time.current) }
  end

  def published?
    published_at.present? && published_at <= Time.current
  end

  def unpublished?
    !published?
  end

  def publish!
    update!(published_at: Time.current)
  end

  def unpublish!
    update!(published_at: nil)
  end

  private

  def apply_published_flag
    return unless published.in?([ true, false, "1", "0", 1, 0 ])

    if ActiveRecord::Type::Boolean.new.cast(published)
      self.published_at ||= Time.current
    else
      self.published_at = nil
    end
  end
end
