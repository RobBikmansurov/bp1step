class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new   # guest user (not logged in)

    if user.roles.count == 0
      can :read, :all #for guest without roles
      cannot :show, User
    else  #зарегистрированные пользователи хотя бы с одной ролью могут:
      can :read, User   # видеть подробности о других пользователях
      cannot :edit_document_place, Document
      cannot :edit_place, Contract

      if user.has_role? :user
        can :view_document, Document  # просматривать файл с документомu.
      end

      if user.has_role? :author
        can :create, Document
        can [:update, :destroy], Document, :owner_id => user.id  # документ владельца
        can :manage, [Directive, Term]
        can :view_document, Document  # просматривать файл с документом
        can :edit_document, [Document]  # может брать исходник документа
      end

      if user.has_role? :keeper
        can :edit_contract_place, Contract  # может изменять место хранения договора
        can :edit_document_place, Document  # может изменять место хранения документа
      end

      if user.has_role? :owner  # владелец процесса
        can [:update, :create], Document
        can :manage, [Directive, Term]
        can :manage, [BproceBapp, BproceIresource]
        can :update, Bproce, :user_id => user.id  # процесс владельца
        can :manage, BusinessRole  # роли в процессе владельца
        can :manage, Metric
        can :manage, [Contract, Agent]
      end

      if user.has_role? :analitic
        can [:update, :create], Document
        can :manage, [Bproce, Bapp, BusinessRole, BproceBapp, Term, Contract, Agent]
        can :manage_tag, [Bproce] # может редактировать теги процессов
        can :edit_document, [Document]  # может брать исходник документа
        can :manage, Metric
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
