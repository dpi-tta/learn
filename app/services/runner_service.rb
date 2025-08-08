# frozen_string_literal: true

require "http"
require "json"

class RunnerService
  API_KEY  = Rails.application.credentials.dig(:runner, :api_key)
  ENDPOINT = Rails.application.credentials.dig(:runner, :url) + "/execute"
  OPEN_TIMEOUT = 5   # seconds
  READ_TIMEOUT = 5

  Result = Struct.new(:success?, :stdout, :stderr, :exit_code, :error, keyword_init: true)

  def self.execute(code:)
    new(code).call
  end

  def initialize(code)
    @code = code.to_s
  end

  def call
    return error_result("empty code") if @code.strip.empty?
    return error_result("missing API key") if API_KEY.to_s.empty?

    response = HTTP
      .timeout(connect: OPEN_TIMEOUT, read: READ_TIMEOUT)
      .auth("Bearer #{API_KEY}")
      .post(ENDPOINT, json: { code: @code })

    payload  = parse_json(response.to_s)

    Result.new(
      success?:   response.status.success?,
      stdout:     payload["stdout"],
      stderr:     payload["stderr"],
      exit_code:  payload["exit_code"],
      error:      payload["error"]
    )
  rescue HTTP::TimeoutError
    error_result("runner timeout")
  rescue => e
    error_result(e.message)
  end

  private

  def parse_json(body)
    JSON.parse(body)
  rescue JSON::ParserError
    {}
  end

  def error_result(msg)
    Result.new(success?: false, error: msg)
  end
end
