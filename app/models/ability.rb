class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new   # guest user (not logged in)

    if user.roles.size == 0
      can :read, :all #for guest without roles
      cannot :show, User
    else
      can :view_document, Document  # зарегистрированные пользователи могут просматривать файл с документом
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
