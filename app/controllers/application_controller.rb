class ApplicationController < ActionController::Base
  include Authentication
  include HttpBasicAuthenticatable
end
