class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  include HttpBasicAuthenticatable
end
