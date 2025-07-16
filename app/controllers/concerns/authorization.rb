module Authorization
  extend ActiveSupport::Concern
  include Pundit::Authorization

  def pundit_user
    Current.user
  end
end
