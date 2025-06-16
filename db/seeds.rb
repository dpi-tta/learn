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
  title: "Onboarding",
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
  title: "HTML & CSS",
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

data_structures_and_algorithms_course = Course.find_or_create_by(
  title: "Data Structures, Algorithms, and Acing Coding Interviews",
  description: <<~DESCRIPTION
    This course focuses on fundamental data structures and algorithms, as well as techniques for acing coding interviews.
    You will practice solving common algorithmic problems and learn strategies to approach and solve these problems effectively.
    By the end of this module, you will be able to: Understand and implement common data structures, Solve algorithmic problems using efficient techniques, Prepare for technical coding interviews, Demonstrate problem-solving skills and algorithmic thinking.
  DESCRIPTION
)

data_structures_and_algorithms_slugs = [
  "ruby-data-structures-algorithms-intro",
  "ruby-data-structures-algorithms-two-sum",
  "ruby-data-structures-algorithms-most-frequent-element-in-array",
  "ruby-data-structures-algorithms-longest-consecutive-sequence",
  "ruby-data-structures-algorithms-balanced-parentheses",
  "ruby-data-structures-algorithms-palindrome",
  "ruby-data-structures-algorithms-climbing-stairs",
  "ruby-data-structures-algorithms-kth-largest-element",
  "ruby-data-structures-algorithms-first-unique-character-in-string",
  "ruby-data-structures-algorithms-find-height-of-binary-tree",
  "ruby-data-structures-algorithms-reverse-linked-list"
]

data_structures_and_algorithms_slugs.each_with_index do |slug, index|
  lesson = Lesson.find_by(slug: slug)
  if lesson
    CourseLesson.find_or_create_by!(course: data_structures_and_algorithms_course, lesson: lesson) do |cl|
      cl.position = index
    end
    puts "Added #{lesson.slug} to #{data_structures_and_algorithms_course.title}"
  else
    puts "⚠️ Lesson not found: #{slug}"
  end
end

capstone_course = Course.find_or_create_by(
  title: "Capstone Project",
  description: <<~DESCRIPTION
    This course is the culmination of your learning journey, where you will apply all the skills acquired throughout the program to design, build, and present your own software project.
    From ideation to deployment, you will learn how to conceptualize a project, write functional requirements, and bring your idea to life.
    The course guides you through noticing good ideas, writing a functional specification, coding, deploying, and preparing a professional presentation to showcase your project.

    ## Learning Objectives:

    - Identify and develop a project idea based on real-world problems or creative inspiration.
    - Write clear functional requirements and specifications to define the scope and features of your project.
    - Translate project specifications into working code.
    - Deploy your application to a production environment.
    - Prepare and deliver a polished presentation of your project, showcasing its features and technical implementation.
  DESCRIPTION
)

capstone_slugs = [
  "building-your-own-idea",
  "noticing-a-project-idea",
  "identifying-pain-points",
  "gathering-user-feedback",
  "writing-functional-requirements",
  "keep-it-simple",
  "getting-started-coding-your-project",
  # TODO: deploying to Render
  "estimating-and-prioritizing-work",
  "presenting-your-project",
  "how-to-get-your-first-5-users"
]

capstone_slugs.each_with_index do |slug, index|
  lesson = Lesson.find_by(slug: slug)
  if lesson
    CourseLesson.find_or_create_by!(course: capstone_course, lesson: lesson) do |cl|
      cl.position = index
    end
    puts "Added #{lesson.slug} to #{capstone_course.title}"
  else
    puts "⚠️ Lesson not found: #{slug}"
  end
end

# TODO: VS Code & Terminal Essentials
# TODO: Ruby
# TODO: Writing Our Own Programs
# TODO: Interviewing
# TODO: HTTP Requests & APIs
# TODO: Web Apps
# TODO: Database Architecture
# TODO: GitHub Workflow
# TODO: Full Stack Web Apps
# TODO: Industrial

puts "✅ Done seeding courses and lessons."
