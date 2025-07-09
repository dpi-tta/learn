module HttpBasicAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authenticate, if: -> { Rails.env.production? }
  end

  private

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      { username:, password: } == Rails.application.credentials.http_basic_authenticate
    end
  end
end
