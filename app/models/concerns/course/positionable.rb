module Course::Positionable
  extend ActiveSupport::Concern

  included do
    validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }

    scope :ordered, -> { order(:position) }

    before_validation :assign_position, on: :create
  end

  LEVELS = {
    intro:       { range: 0..99 },
    foundations: { range: 100..199 },
    bridge:      { range: 200.. }
  }.freeze

  def level
    LEVELS.each do |key, config|
      return key if config[:range].include?(position)
    end
  end

  private

  def assign_position
    return if position.present?

    self.position = maximum(:position).to_i + 1 if course
  end
end
