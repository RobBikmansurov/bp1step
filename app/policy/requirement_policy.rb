# frozen_string_literal: true

# policy for requirement actions
class RequirementPolicy
  def initialize; end

  def allowed?(user)
    user.role? :user
  end
end
