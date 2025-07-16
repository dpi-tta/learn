class CoursePolicy < ApplicationPolicy
  attr_reader :user, :course

  def initialize(user, course)
    @user = user
    @course = course
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    return false unless user.present?

    user.admin?
  end

  def new?
    create?
  end

  def update?
    return false unless user.present?

    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    return false unless user.present?

    user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
