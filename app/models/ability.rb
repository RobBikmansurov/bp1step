class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new   # guest user (not logged in)

    if user.roles.size == 0
      can :read, :all #for guest without roles
      cannot :show, User
    else  #зарегистрированные пользователи могут:
      can :view_document, Document  # просматривать файл с документом
      can :read, User   # видеть подробности о других пользователях
      if user.has_role? :admin
        can :assign_roles, User   # администратор может изменять роли доступа пользователям
        can :manage, [User, Workplace, Bapp]
      end
      if user.has_role? :analitic
        can :assign_roles, User   # администратор может изменять роли доступа пользователям
        can :manage, [Bproce, BusinessRole, Document]
      end
      if user.has_role? :autor
        can :manage, [Directive, Document]
      end
    end
  
  end         
end
