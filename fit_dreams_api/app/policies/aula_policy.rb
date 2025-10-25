class AulaPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    staff?
  end

  def update?
    staff?
  end

  def destroy?
    staff?
  end

  def enroll?
    user&.aluno?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def staff?
    user&.admin? || user&.professor?
  end
end
