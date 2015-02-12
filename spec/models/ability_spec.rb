require "cancan/matchers"
require "spec_helper"

describe Ability do
  before (:all) do
    [UserRole, Role, User].each do | model |
      model.all.each { |r| r.destroy }
    end
    @role = FactoryGirl.create(:role)
    @role.name = 'user'
    @role.save
  end
  before (:each) do
    @role = Role.create(name: 'user', description: 'default role') # создать роль по умолчанию
    @role.save
    @user = FactoryGirl.create(:user) # создать пользователя с ролью по умолчанию
  end

  context "unauthorized user or user without roles" do   # незарегистрированный пользователь
    ability = Ability.new(@user)
    [Bapp, Bproce, BproceBapp, BusinessRole, Directive, Document, Role, Workplace, Iresource, Term, User].each do |model|
      it "can :read '#{model.to_s}' but can't :manage them" do
        expect(ability).to be_able_to(:read, model.new)
        expect(ability).not_to be_able_to(:manage, model.new)
        expect(ability).not_to be_able_to(:create, model.new)
        expect(ability).not_to be_able_to(:update, model.new)
        expect(ability).not_to be_able_to(:destroy, model.new)
      end
    end
    it "can't :show User" do
      expect(ability.can?(:show, User)).to be_falsey # не видит подробностей о пользователе
      expect(ability.can?(:index, User)).to be_truthy # видит список пользователей
    end
    it "can't assign Roles" do
      expect(ability.can?(:assign_roles, User)).to be_falsey
    end
    it "can't view Document" do
      expect(ability.can?(:view_document, Document)).to be_falsey  # не может просмотреть файл документа
    end
    it "can't view Document place" do
      expect(ability.can?(:edit_document_place, Document)).to be_falsey  # не может изменит место хранения документа
    end

  end

  context "authorized user with role :user" do   # зарегистрированный пользователь с ролью Пользователь
    if Role.count == 0
      role = FactoryGirl.create(:role)
    else
      role = Role.first
    end
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_by_name(role.name)
    it "has role" do
      expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)

    it "can view Document" do
      #expect(ability.can?(:view_document, Document)).to be_truthy  # может просмотреть файл документа
      expect(ability).to be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      expect(ability).to be_able_to(:read, User)
      expect(ability.can?(:show, User)).to be_truthy # видит подробностей о пользователе
    end
  end

  context "authorized user with role :author" do   # Писатель, владелец документа
    role = Role.first
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    role.name = :author
    role.save
    @user.roles << Role.find_by_name(role.name)
    it "has roles" do
      expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)

    [Directive, Term].each do |model|
      it "can :manage '#{model.to_s}'" do
        expect(ability).to be_able_to(:manage, model.new)
        expect(ability).to be_able_to(:create, model.new)
        expect(ability).to be_able_to(:update, model.new)
        expect(ability).to be_able_to(:destroy, model.new)
      end
    end
    it "can :manage Document" do
      expect(ability).to be_able_to(:create, Document)
      @document = FactoryGirl.create(:document)
      @document.owner_id = @user.id
      @document.save
      expect(ability).to be_able_to(:update, Document, @document)
      expect(ability).to be_able_to(:destroy, Document)
    end

    it "can view Document" do
      expect(ability.can?(:view_document, Document)).to be_truthy  # может просмотреть файл документа
      expect(ability).to be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can't view Document place" do
      expect(ability.can?(:edit_document_place, Document)).to be_falsey  # не может изменит место хранения документа
    end
    it "can :show User" do
      expect(ability).to be_able_to(:read, User)
      expect(ability.can?(:show, User)).to be_truthy # видит подробностей о пользователе
    end
  end

  context "authorized user with role :keeper" do   # Владелец процесса
    role = Role.first
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    role.name = :keeper
    role.save
    @user.roles << Role.find_by_name(role.name)

    it "has roles" do
      expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)
    it "can edit Document place" do
      expect(ability.can?(:edit_document_place, Document)).to be_truthy  # может изменит место хранения документа
      expect(ability).to be_able_to(:edit_document_place, Document)
    end
    it "can edit Contract place" do
      expect(ability.can?(:edit_contract_place, Contract)).to be_truthy  # может изменит место хранения договора
      expect(ability).to be_able_to(:edit_contract_place, Contract)
    end
  end

  context "authorized user with role :owner" do   # Владелец процесса
    role = Role.first
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    role.name = :owner
    role.save
    @user.roles << Role.find_by_name(role.name)

    it "has roles" do
      expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)

    [Directive, Term, BproceBapp, BproceIresource, BusinessRole, Metric].each do |model|
      it "can :manage '#{model.to_s}'" do
        expect(ability).to be_able_to(:create, model.new)
        expect(ability).to be_able_to(:update, model.new)
        expect(ability).to be_able_to(:destroy, model.new)
      end
    end
    [Document].each do |model|
      it "can :manage '#{model.to_s}'" do
        expect(ability).to be_able_to(:create, model.new)
        expect(ability).to be_able_to(:update, model.new)
      end
    end

    it "can :manage Bproce" do
      @bproce = FactoryGirl.create(:bproce)
      @bproce.user_id = @user.id
      user = @user
    end

    it "can view Document" do
      expect(ability.can?(:view_document, Document)).to be_truthy  # может просмотреть файл документа
      expect(ability).to be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      expect(ability).to be_able_to(:read, User)
      expect(ability.can?(:show, User)).to be_truthy # видит подробностей о пользователе
    end
  end

  context "authorized user with role :analitic" do   # Бизнес-аналитик
    role = Role.first
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    role.name = :analitic
    role.save
    @user.roles << Role.find_by_name(role.name)

    it "has roles" do
      expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)

    it "can view Document" do
      expect(ability.can?(:view_document, Document)).to be_truthy  # может просмотреть файл документа
      expect(ability).to be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      expect(ability).to be_able_to(:read, User)
      expect(ability.can?(:show, User)).to be_truthy # видит подробностей о пользователе
    end
  end

  context "authorized user with role :admin" do   # Администратор
    role = Role.first
    role.name = :user
    role.save
    @user = FactoryGirl.create(:user)
    role.name = :admin
    role.save
    @user.roles << Role.find_by_name(role.name)

    it "has roles" do
     expect(@user.roles.count).to eq(1)
    end

    ability = Ability.new(@user)

    it "can view Document" do
      expect(ability.can?(:view_document, Document)).to be_truthy  # может просмотреть файл документа
      expect(ability).to be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      expect(ability).to be_able_to(:read, User)
      expect(ability.can?(:show, User)).to be_truthy # видит подробностей о пользователе
    end
  end

end