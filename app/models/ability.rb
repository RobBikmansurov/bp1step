# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.roles.count.zero?
      can :read, :all # for guest without roles
      cannot :show, User
    else # зарегистрированные пользователи хотя бы с одной ролью могут:
      can :read, User # видеть подробности о других пользователях
      cannot :edit_document_place, Document
      cannot :edit_place, Contract

      if user.role? :user
        can :view_document, Document # просматривать файл с документомu.
      end

      if user.role? :author
        can :create, Document
        can %i[update destroy clone], Document, owner_id: user.id # документ владельца
        can :manage, [Directive, Term]
        can :view_document, Document # просматривать файл с документом
        can :edit_document, [Document] # может брать исходник документа
        can [:read], [Agent, Contract]
        can %i[create_user update], Letter # назначать исполнителей писем
        can [:create], [Task] # создавать Задачи
      end

      if user.role? :keeper
        can :edit_contract_place, Contract  # может изменять место хранения договора
        can :edit_document_place, Document  # может изменять место хранения документа
      end

      if user.role? :owner # владелец процесса
        can %i[update create clone], Document
        can :manage, [Directive, Term]
        can :crud, [BproceBapp, BproceIresource]
        can :update, Bproce, user_id: user.id # процесс владельца
        can :crud, BusinessRole # роли в процессе владельца
        can :crud, Metric
        can :crud, [Contract, Agent, ContractScan]
        can :crud, [Task, Requirement]
      end

      if user.role? :analitic
        can %i[update create clone], Document
        can :crud, [Bproce, Bapp, BusinessRole, BproceBapp, Term, Contract, Agent, ContractScan]
        can :manage_tag, [Bproce] # может редактировать теги процессов
        can :edit_document, [Document] # может брать исходник документа
        can :crud, Metric
        can :crud, [Task, Requirement]
      end

      if user.role? :secretar
        can %i[create_user create update], Letter # назначать исполнителей писем, создать, изменить письмо
        can :registr, Letter # регистрирует корреспонденцию
        can :create_outgoing, Letter # создает исходящее по входящему
      end

      if user.role? :admin
        can :assign_roles, User # администратор может изменять роли доступа пользователям
        can :manage, [User, Workplace, Bapp, Iresource, Term]
        can :crud, [MetricValue]
        can :manage_tag, [Bproce, Bapp] # может редактировать теги процессов, приложений
      end

      if user.role? :security
        can :assign_roles, User # администратор доступа может изменять роли доступа пользователям
      end
    end
  end
end
