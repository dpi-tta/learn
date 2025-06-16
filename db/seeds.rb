# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# NOTE: run `ruby script/import_lessons_from_github.rb` before seeding

puts "Seeding courses and lesson assignments..."

intro_onboarding_course = Course.find_or_create_by(
  title: "Onboarding (INTRO)",
  description: <<~DESCRIPTION
    This course provides a comprehensive introduction to essential tools and practices for effective communication, time management, and collaborative software development. You will learn how to navigate digital platforms, engage in professional interactions, manage projects using agile methodologies, and maintain robust cybersecurity practices.
    ## Learning Objectives:
    - Navigate and utlize the content management and communication platforms effectively.
    - Implement best pracuces for proressional communication in virtual environments.
    - Use email and calendar tools to manage time and responsibilities efficiently.
    - Set up and maintain password managers to enhance digital security.
    - Participate in agile ceremonies to improve team collaboration and project management skills.
  DESCRIPTION
)

onboarding_slugs = [
  "join-the-chat",
  "setup-your-email",
  "setup-github-profile",
  "setup-til-blog", # or "keeping-a-learning-journal" — adjust if needed
  "daily-stand-ups-and-agile-ceremonies",
  "taking-notes",
  "setup-a-password-manager",
  "setup-your-internal-profile" # optional
]

onboarding_slugs.each_with_index do |slug, index|
  lesson = Lesson.find_by(slug: slug)
  if lesson
    CourseLesson.find_or_create_by!(course: intro_onboarding_course, lesson: lesson) do |cl|
      cl.position = index
    end
    puts "Added #{lesson.slug} to #{intro_onboarding_course.title}"
  else
    puts "⚠️ Lesson not found: #{slug}"
  end
end

intro_html_css_course = Course.find_or_create_by(
  title: "HTML & CSS (INTRO)",
  description: <<~DESCRIPTION
    This course provides an extensive overview of HTML and CSS, starting with fundamental concepts and advancing to more complex topics such as layout systems, responsive design, and deployment. You will learn how to structure web pages, style them with CSS, and eventually deploy a project online.
    ## Learning Obiectives:
    - Understand and apply the basic structure of HTML documents.
    - Utilize CSS to style web pages and create visually appealing layouts.
    - Implement responsive design principles to ensure web pages are mobile-friendly.
    - Use version control with GitHub to manage and collaborate on code.
    - Deploy a static website to the hosting platform Render.
  DESCRIPTION
)

html_css_slugs = [
  "html-css-basics",
  "github-codespaces-vscode",
  "domain-names"
]

html_css_slugs.each_with_index do |slug, index|
  lesson = Lesson.find_by(slug: slug)
  if lesson
    CourseLesson.find_or_create_by!(course: intro_html_css_course, lesson: lesson) do |cl|
      cl.position = index
    end
    puts "Added #{lesson.slug} to #{intro_html_css_course.title}"
  else
    puts "⚠️ Lesson not found: #{slug}"
  end
end

# TODO: capstone course
# TODO: data structures and algorithms course

puts "✅ Done seeding courses and lessons."
