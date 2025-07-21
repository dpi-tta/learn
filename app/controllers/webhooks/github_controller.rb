module Webhooks
  class GithubController < ApplicationController
    allow_unauthenticated_access
    skip_before_action :verify_authenticity_token
    skip_before_action :http_basic_authenticate, if: -> { Rails.env.production? } # HttpBasicAuthenticatable

    def create
      request_body = request.raw_post
      signature = "sha256=" + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha256"),
        Rails.application.credentials.dig(:github, :client_secret),
        request_body
      )

      unless Rack::Utils.secure_compare(signature, request.headers["X-Hub-Signature-256"].to_s)
        Rails.logger.warn("Invalid GitHub webhook signature")
        return head :unauthorized
      end

      payload = JSON.parse(request_body)

      repository_full_name = payload.dig("repository", "full_name")

      unless repository_full_name
        Rails.logger.info("Repository full name not provided")
        return head :ok
      end

      repo_url = "https://github.com/#{repository_full_name}"

      # TODO: handle different branches besides main
      lesson = Lesson.find_by(github_repository_url: repo_url)

      if lesson
        Rails.logger.info("Saving lesson to trigger GitHub Sync: #{repo_url}")
        lesson.save!
      else
        Rails.logger.info("Unable to find existing lesson for URL: #{repo_url}")
        Rails.logger.info("Creating lesson via GitHub URL: #{repo_url}")
        Lesson.create(github_repository_url: repo_url)
      end

      head :ok
    end
  end
end
