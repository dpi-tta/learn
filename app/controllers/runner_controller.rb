class RunnerController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ execute ]

  def execute
    payload = JSON.parse(request.raw_post) rescue {}
    code = payload["code"].to_s

    result = RunnerService.execute(code: code)

    if result.success?
      render json: {
        stdout: result.stdout,
        stderr: result.stderr,
        exit_code: result.exit_code
      }
    else
      render json: { error: result.error }, status: :bad_gateway
    end
  end
end
