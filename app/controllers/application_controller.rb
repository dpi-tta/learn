class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  inlcude HttpBasicAuthenticatable
end
