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

puts "Seeding users..."

user_attributes_list = [
  { email_address: "ihera2@uillinois.edu", admin: true }
]

user_attributes_list.each do |attributes|
  user = User.find_or_create_by!(email_address: attributes[:email_address]) do |u|
    u.admin = attributes[:admin]
    u.password = Rails.env.production? ? SecureRandom.alphanumeric(16) : "password"
  end

  if user.persisted?
    puts "✅ Added #{user.email_address}, admin: #{user.admin?}"
  else
    puts "⚠️ Unable to create user: #{attributes}"
  end
end

puts "Seeding courses and lesson assignments..."

onboarding_course = Course.find_or_create_by!(title: "Onboarding") do |course|
  course.position = 0
  course.published = true
  course.description = <<~DESCRIPTION
    This course provides a comprehensive introduction to essential tools and practices for effective communication, time management, and collaborative software development. You will learn how to navigate digital platforms, engage in professional interactions, manage projects using agile methodologies, and maintain robust cybersecurity practices.

    ## Learning Objectives

    - Navigate and utlize the content management and communication platforms effectively.
    - Implement best pracuces for proressional communication in virtual environments.
    - Use email and calendar tools to manage time and responsibilities efficiently.
    - Set up and maintain password managers to enhance digital security.
    - Participate in agile ceremonies to improve team collaboration and project management skills.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

onboarding_slugs = [
  # TODO: orientation (video, submitting issues, how to approach lessons etc.)
  "join-the-chat",
  "asking-questions",
  "setup-your-email",
  "setup-your-calendar",
  "setup-a-password-manager",
  "daily-stand-ups-and-agile-ceremonies",
  "setup-github-profile",
  "setup-til-blog", # or "keeping-a-learning-journal" — adjust if needed
  "taking-notes",
  "setup-your-internal-profile" # optional
]

html_css_course = Course.find_or_create_by!(title: "HTML & CSS") do |course|
  course.position = 10
  course.published = true
  course.description = <<~DESCRIPTION
    This course provides an extensive overview of HTML and CSS, starting with fundamental concepts and advancing to more complex topics such as layout systems, responsive design, and deployment. You will learn how to structure web pages, style them with CSS, and eventually deploy a project online.

    ## Learning Objectives

    - Understand and apply the basic structure of HTML documents.
    - Utilize CSS to style web pages and create visually appealing layouts.
    - Implement responsive design principles to ensure web pages are mobile-friendly.
    - Use version control with GitHub to manage and collaborate on code.
    - Paricipate in a code review
    - Deploy a static website to a cloud hosting platform.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

html_css_slugs = [
  "html-css-basics",
  "github-codespaces-vscode",
  "portfolio",
  "portfolio-code-review",
  "render-deploy-static-site",
  "domain-names"
  # TODO: HTML/CSS Reference and Resources
  # TODO: Design
]

vs_code_and_terminal_essentials_course = Course.find_or_create_by!(title: "VS Code & Terminal Essentials") do |course|
  course.position = 11
  course.published = true
  course.description = <<~DESCRIPTION
    This course is designed to help you master your developer workflow in Visual Studio Code (VS Code) while working in Codespaces. You'll learn the essential features of VS Code, explore powerful tips and keyboard shortcuts to boost efficiency, and pick up handy tricks to streamline your setup. By the end, you'll be equipped with practical skills to code faster and more effectively in any project.

    ## Learning Objectives

    - Navigate the Visual Studio Code (VS Code) interface to enhance your productivity.
    - Apply powerful keyboard shortcuts and editor tricks to accelerate your coding workflow.
    - Master terminal commands to manage your development environment efficiently.
    - Implement productivity tips tailored for macOS and Windows to optimize your setup.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

vs_code_and_terminal_essentials_slugs = [
  "vs-code-basics",
  "terminal-basics"
  # TODO: mac tips
  # TODO: windows tips
]

ruby_course = Course.find_or_create_by!(title: "Ruby") do |course|
  course.position = 20
  course.published = true
  course.description = <<~DESCRIPTION
    This course provides an introduction to Object Oriented Programming (OOP) with Ruby.
    It covers the basics of Ruby (syntax, data types, methods, conditionals, loops, and creating classes).
    The course then builds on your fundamentals of Ruby programming, focusing on practical skills and real-world applications.
    By the end you will be able to write, run, and debug your own robust Ruby programs, use Ruby gems, and employ proper coding style and testing techniques.

    ## Learning Objectives
    - Understand the benefits of Object Oriented Programming
    - Understand the basic syntax of Ruby
    - Learn the fundamental building blocks of object oriented programming
    - Utilize the fundamental building blocks to solve challenges in the Ruby Dojo
    - Write and execute Ruby programs in a real development environment.
    - Implement debugging techniques to identify and fix errors in Ruby code.
    - Apply proper coding styles and conventions in Ruby to create readable and maintainable code.
    - Use Ruby gems to enhance functionality and leverage existing code.
    - Write and run tests using MiniTest to ensure code reliability and quality.
    - Create a command-line interface (CLI) Ruby project.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

# Use singular when referring to a Ruby class or concept name,
# use plural when the lesson covers a category or repeated structure.
# codespaces for ruby programs lesson?
ruby_slugs = [
  "ruby-why",
  "ruby-basics",
  "ruby-string",  # TODO: regex?
  "ruby-numeric",
  "ruby-date",
  "ruby-conditionals",
  "ruby-array",
  "ruby-loops",
  "ruby-hash",
  "ruby-enumerables",
  "ruby-io",
  "ruby-class",
  "ruby-oop",
  # "ruby-dojo"
  # TODO: exceptions and errors?
  "ruby-debugging-tips",
  "ruby-style-basics",
  "ruby-minitest",
  "ruby-command-line-interface-cli-project",
  "ruby-next-steps"
]

interviewing_course = Course.find_or_create_by!(title: "Interviewing") do |course|
  course.position = 22
  course.published = true
  course.description = <<~DESCRIPTION
    This course provides a comprehensive introduction to the essential components of the job-search and interview process, guiding you from technical problem-solving to professional communication and career exploration. You will learn how to approach technical interviews with confidence, craft strong behavioral responses using established frameworks, build polished professional materials, and identify career paths aligned with your strengths and interests.

    ## Learning Objectives

    - Practice solving coding challenges while demonstrating object-oriented programming fundamentals, debugging skills, and clear communication.
    - Apply the STAR method to structure behavioral interview responses that highlight your impact and experience.
    - Create a polished, one-page resume that effectively showcases your technical and transferable skills.
    - Develop and deliver a confident 45-60 second elevator speech tailored to networking and interview settings.
    - Explore a variety of technical and client-facing career paths to identify roles that best match your goals and strengths.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

interviewing_slugs = [
  "interview-prep-technical",
  "interview-prep-behavioral",
  "interview-prep-resume",
  "interview-prep-elevator-speech",
  "interview-prep-career-exploration"
]

# TODO: HTTP Requests & APIs
http_requests_course = Course.find_or_create_by!(title: "HTTP Requests and APIs") do |course|
  course.position = 30
  course.description = <<~DESCRIPTION

  DESCRIPTION

  puts "Created course: #{course.title}"
end

http_requests_slugs = [
  "web-and-http"
  # TODO: APIs and Credentials
  # TODO: putting it all together
  # TODO: chat gpt cli
]

web_apps_course = Course.find_or_create_by!(title: "Web Applications") do |course|
  course.position = 31
  course.description = <<~DESCRIPTION
    This course introduces the core principles of building interactive web applications. You'll learn how to respond to HTTP requests, define routes, use view templates for dynamic content, work with user input, and connect to external APIs. By the end, you'll develop and deploy your own web application.

    ## Learning Objectives

    - Grasp the fundamentals of routing and managing HTTP requests and responses.
    - Use view templates to separate presentation from application logic.
    - Handle form submissions and process user input effectively.
    - Connect and interact with third-party APIs.
    - Build and deploy a Sinatra-based web application to a cloud hosting platform.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

web_apps_slugs = [
  #   - TODO: respond to http requests with a simple web app
  #   - TODO: view templates
  #   - html-css-erb-style-basics
  #   - TODO: links + routes
  #   - TODO: refactor: dynamic routes
  #   - TODO: query strings and forms
  #   - TODO: web app project
  #     - writing-functional-requirements
]

# TODO: Database Architecture
#   - database-architecture-records-and-relationships
#   - database-architecture-offer-right

github_workflow_course = Course.find_or_create_by!(title: "GitHub Workflow") do |course|
  course.position = 22
  course.description = <<~DESCRIPTION
    This course provides an in-depth exploration of GitHub as a key tool for version control, collaboration, and project management in software development.
    Students will learn to set up their GitHub profiles, use Git commands for tracking changes, and collaborate effectively through branching, merging, and pull requests.
    The course also covers the basics of GitHub project boards for organizing work and introduces CI/CD with GitHub Actions to automate testing and deployment.

    ## Learning Objectives:

    - Set up and customize a GitHub profile to establish an online developer presence.
    - Understand and implement Git version control for tracking and managing changes to code.
    - Use Git commands via the command line to commit, push, branch, and merge code effectively.
    - Collaborate with teams by reviewing code and submitting pull requests for shared projects.
    - Organize and track project tasks using GitHub Project Boards.
    - Automate testing and deployment processes using GitHub Actions for CI/CD pipelines.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

github_workflow_slugs = [
  "setup-github-profile",
  # TODO: git gui, git cli, commit, push, branch, merge
  "code-review",
  "issues-branching-kanban",
  "continuous-integration-continuous-deployment"
]

full_stack_web_apps_course = Course.find_or_create_by!(title: "Full Stack Web Applications") do |course|
  course.position = 100
  course.description = <<~DESCRIPTION
    This course equips students with the essential tools, frameworks, and methodologies used in full stack web development. Through hands-on practice, students will gain experience working with database design and management, debugging workflows, and frameworks like Ruby on Rails and Bootstrap.

    ## Learning Objectives

    - Develop and debug full stack web applications using Ruby on Rails
    - Build a responsive frontend using Bootstrap
    - Apply the Model-View-Controller (MVC) pattern.
    - Manage databases through migrations, ORM (Object-relational Mapping) queries, and SQL.
    - Implement authentication and authorization.
    - Refactor applications with helper and instance methods to improve clarity and structure.
    - Leverage GitHub workflow and peer code review
    - Use scripts, generators and scaffolding to streamline development.
    - Integrate JavaScript to build dynamic user interfaces.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

# TODO: add more lessons here
# bootstrap
# RCAV
# hard coded routes
# dynamic routes
# dynamic path segments
# reading console logs and error messages
# active record / migrations
# model instance methods
# session
# association accessors
# validations
# CRUD
# MVC
# generators
# sample data, tasks
#
# helper methods
# - named routes / links
# - forms
# - link_to
# - partials
# user auth
# ajax / javascrip
# pundit authorization
full_stack_web_apps_slugs = [
  "debugging",
  "rails-migrations",
  "reading-documentation-and-newsletters"
]

capstone_course = Course.find_or_create_by!(title: "Capstone Project") do |course|
  course.position = 110
  course.published = true
  course.description = <<~DESCRIPTION
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

  puts "Created course: #{course.title}"
end

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

patterns_of_enterprise_applications_course = Course.find_or_create_by!(title: "Patterns of Enterprise Applications: Design, Architecture, and Best Practices") do |course|
  course.position = 111
  course.published = true
  course.description = <<~DESCRIPTION
    This course delves into the essential design patterns, architectural principles, and best practices for building scalable and maintainable enterprise applications. Students will learn to simplify complex systems through service objects, embrace domain-driven design for tackling business logic, and craft clean, human-readable code. Additionally, the course explores modular programming, component-based view templates, and event-driven architectures to improve code organization, reusability, and scalability in large applications.

    ## Learning Objectives:

    - Understand key design patterns and architectural principles for building enterprise-level applications.
    - Simplify application logic and enhance code reusability through service objects.
    - Embrace complexity using domain-driven design to better align code with business requirements.
    - Write clean, readable, and maintainable code that is intuitive for other developers to understand.
    - Organize code effectively using modules and the DRY (Don’t Repeat Yourself) principle to reduce redundancy.
    - Implement component-based view templates to create reusable, maintainable front-end architecture.
    - Scale applications efficiently using event-driven architectures to handle complex, asynchronous workflows.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

patterns_of_enterprise_applications_slugs = [
  "patterns-of-enterprise-application-architecture-intro",
  "service-objects",
  "domain-driven-design",
  "clean-code",
  "writing-code-for-humans",
  "rails-concerns",
  "component-based-view-templates",
  "rails-pub-sub-pattern"
]

extra_topics_course = Course.find_or_create_by!(title: "Extra Topics") do |course|
  course.position = 112
  course.published = true
  course.description = <<~DESCRIPTION
    This course expands on foundational software development concepts, diving deeper into advanced topics such as security, API integrations, performance optimization, and mobile-friendly design.
    Through practical exercises and real-world applications, students will enhance their skills in managing complex Rails applications, organizing JavaScript code, ensuring quality through testing, and integrating third-party services like maps and charts.
    The course also covers best practices for securing credentials, deploying applications, and improving accessibility, SEO, and user experience.

    ## Learning Objectives:

    - Implement style guides, linters, and semantic HTML to ensure code quality, readability, and accessibility.
    - Create more efficient Rails applications by nesting routes and attributes, implementing background jobs, and optimizing performance.
    - Securely manage credentials, including GitHub sign-in with Devise OmniAuth and encrypted credentials.
    - Integrate third-party services such as Mapbox, Google Maps, ChartKick, and APIs like OpenAI into Rails applications.
    - Organize and enhance JavaScript functionality using Stimulus and object-oriented JavaScript techniques.
    - Automate tasks like sample data loading, web scraping, and data export with rake tasks and CSV management.
    - Perform quality assurance and testing with tools like RSpec, ensuring robust and bug-free applications.
    - Deploy and monitor Rails applications on platforms like Render while applying best practices for scalability and security.
    - Optimize applications for mobile devices.
    - Integrate email and messaging services for user communication.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

extra_topics_slugs = [
  "setting-up-a-development-environment",
  "style-guides-linters",
  "rails-nested-routes",
  "rails-nested-attributes",
  "how-to-write-a-good-readme",
  "rails-organizing-js-code",
  "js-stimulus",
  "rails-security",
  # TODO: oauth
  # ENV variables + codespace credentials
  "rails-encrypted-credentials",
  "mapbox",
  "charts-graphs-and-data-visualizations",
  "building-for-mobile",
  # TODO: sample data rake task
  # TODO: Loading/Exporting data (CSV, JSON, etc.)
  # TODO: web scraping
  "pagination",
  # TODO: searching, filtering, ransack, pg_search, typeahead
  "rails-performance",
  "background-jobs", # TODO: show how to run in render free tier
  "rails-qa-testing",
  "testing-with-rspec",
  "monitoring-your-application",
  "rails-admin",
  "rails-business-analytics",
  "semantic-html-and-accessibility",
  "search-engine-optimization",
  "artificial-intelligence-overview",
  # TODO: open ai api request
  # TODO: chat gpt cli
  # TODO: deploy rails app to render
  "domain-names",
  "rails-active-storage",
  # TODO: translation and i18n
  "email",
  # TODO: SMS
  "rails-building-apis"
  # TODO: rich text editors
]

# TODO: Bridge Course

data_structures_and_algorithms_course = Course.find_or_create_by!(title: "Data Structures, Algorithms, and Acing Coding Interviews") do |course|
  course.position = 200
  course.published = true
  course.description = <<~DESCRIPTION
    This course focuses on fundamental data structures and algorithms, as well as techniques for acing coding interviews.
    You will practice solving common algorithmic problems and learn strategies to approach and solve these problems effectively.
    By the end of this module, you will be able to: Understand and implement common data structures, Solve algorithmic problems using efficient techniques, Prepare for technical coding interviews, Demonstrate problem-solving skills and algorithmic thinking.
  DESCRIPTION

  puts "Created course: #{course.title}"
end

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

# TODO: Next Steps course


curricula = [
  { course: onboarding_course, slugs: onboarding_slugs },
  { course: html_css_course, slugs: html_css_slugs },
  { course: vs_code_and_terminal_essentials_course, slugs: vs_code_and_terminal_essentials_slugs },
  { course: ruby_course, slugs: ruby_slugs },
  { course: interviewing_course, slugs: interviewing_slugs },
  { course: http_requests_course, slugs: http_requests_slugs },
  { course: web_apps_course, slugs: web_apps_slugs },
  { course: github_workflow_course, slugs: github_workflow_slugs },
  { course: full_stack_web_apps_course, slugs: full_stack_web_apps_slugs },
  { course: capstone_course, slugs: capstone_slugs },
  { course: extra_topics_course, slugs: extra_topics_slugs },
  { course: patterns_of_enterprise_applications_course, slugs: patterns_of_enterprise_applications_slugs },
  { course: data_structures_and_algorithms_course, slugs: data_structures_and_algorithms_slugs }
]

curricula.each do |curriculum|
  curriculum[:slugs].each_with_index do |slug, index|
    lesson = Lesson.find_or_create_by!(
      slug: slug,
      github_repository_url: "https://github.com/dpi-tta-lessons/" + slug
    )
    if lesson
      CourseLesson.find_or_create_by!(course: curriculum[:course], lesson: lesson) do |cl|
        cl.position = index
        puts "Added #{lesson.slug} to #{curriculum[:course].title}"
      end
    else
      puts "⚠️ Lesson not found: #{slug}"
    end
  end
end

puts "✅ Done seeding courses and lessons."
