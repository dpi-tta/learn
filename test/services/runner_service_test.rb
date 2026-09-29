require "test_helper"

class RunnerServiceTest < ActiveSupport::TestCase
  test "reports missing runner URL without making a request" do
    credentials = { runner: { api_key: "test-key" } }

    Rails.application.stub(:credentials, credentials) do
      result = RunnerService.execute(code: "puts 'hello'")

      assert_not result.success?
      assert_equal "missing runner URL", result.error
    end
  end
end
