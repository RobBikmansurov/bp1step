class Ability
  include CanCan::Ability
  # FIXME разобраться с тестированием Ability в rspec

  def initialize(user)
    user ||= User.new   # guest user (not logged in)

    if user.roles.count == 0
      can :read, :all #for guest without roles
      cannot :show, User
    else  #зарегистрированные пользователи хотя бы с одной ролью могут:
      can :view_document, Document  # просматривать файл с документом
      can :read, User   # видеть подробности о других пользователях

      if user.has_role? :user
        can :view_document, Document  # просматривать файл с документом
      end

      if user.has_role? :author
        can :manage, [Directive, Document, Term]
        can :view_document, Document  # просматривать файл с документом
        can :edit_document, [Document]  # может брать исходник документа
      end

      if user.has_role? :owner  # владелец процесса
        can :manage, [Directive, Document, Term]
        can :manage, [BproceBapp, BproceIresource]
        can :update, Bproce, :user_id => user.id  # процесс владельца
        can :manage, BusinessRole  # роли в процессе владельца
      end

      if user.has_role? :analitic
        can :manage, [Bproce, Bapp, BusinessRole, Document, BproceBapp, Term]
        can :manage_tag, [Bproce] # может редактировать теги процессов
        can :edit_document, [Document]  # может брать исходник документа
      end

      if user.has_role? :admin
        can :assign_roles, User   # администратор может изменять роли доступа пользователям
        can :manage, [User, Workplace, Bapp, Iresource, Term]
        can :manage_tag, [Bproce, Bapp] # может редактировать теги процессов, приложений
      end

      if user.has_role? :security
        can :assign_roles, User   # администратор доступа может изменять роли доступа пользователям
      end

    end

  end
end
