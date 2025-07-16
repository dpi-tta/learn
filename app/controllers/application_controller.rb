class ApplicationController < ActionController::Base
  include Authentication
  include HttpBasicAuthenticatable
  include Pundit::Authorization

  def pundit_user
    Current.user
  end
end
