class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new   # guest user (not logged in)

    if user.roles.size == 0
      cannot :read, User
      can :read, :all #for guest without roles
    else
      #can :read, :all
      if user.has_role? :admin
        can :assign_roles, User   # администратор может изменять роли доступа пользователям
        can :manage, [User, Workplace, Bapp]
      end
      if user.has_role? :analitic
        can :assign_roles, User   # администратор может изменять роли доступа пользователям
        can :manage, [Bproce, BusinessRole, Document]
      end
    end
  
  end         
end
