module CoursesHelper
  def bootstrap_badge_class(level)
    case level
    when :intro       then "bg-success"
    when :foundations then "bg-primary"
    when :bridge      then "bg-danger"
    else "bg-secondary"
    end
  end

  def course_level_hint
    Course::LEVELS.map do |level, config|
      min = config[:range].min
      max = config[:range].end
      label = level.to_s.titleize

      range_text = max.nil? ? "#{min}+" : "#{min}–#{max}"

      "#{range_text}: #{label}"
    end.join(", ")
  end
end
