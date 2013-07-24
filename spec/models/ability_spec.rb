require "cancan/matchers"
require "spec_helper"

PublicActivity.enabled = false

describe Ability do
  before (:all) do
    [UserRole, Role, User].each do | model |
      model.all.each { |r| r.destroy }
    end
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
        ability.should be_able_to(:read, model.new)
        ability.should_not be_able_to(:manage, model.new)
        ability.should_not be_able_to(:create, model.new)
        ability.should_not be_able_to(:update, model.new)
        ability.should_not be_able_to(:destroy, model.new)
      end
    end
    it "can't :show User" do
      ability.can?(:show, User).should be_false # не видит подробностей о пользователе
      ability.can?(:index, User).should be_true # видит список пользователей
    end
    it "can't assign Roles" do
      ability.can?(:assign_roles, User).should be_false
    end
    it "can't view Document" do
      ability.can?(:view_document, Document).should be_false  # не может просмотреть файл документа
    end
    it "can't view Document place" do
      ability.can?(:edit_document_place, Document).should be_false  # не может изменит место хранения документа
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)

    [Directive, Term].each do |model|
      it "can :manage '#{model.to_s}'" do
        ability.should be_able_to(:manage, model.new)
        ability.should be_able_to(:create, model.new)
        ability.should be_able_to(:update, model.new)
        ability.should be_able_to(:destroy, model.new)
      end
    end
    it "can :manage Document" do
      ability.should be_able_to(:create, Document)
      @document = FactoryGirl.create(:document)
      @document.owner_id = @user.id
      @document.save
      ability.should be_able_to(:update, Document, @document)
      ability.should be_able_to(:destroy, Document)
    end

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can't view Document place" do
      ability.can?(:edit_document_place, Document).should be_false  # не может изменит место хранения документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)
    it "can edit Document place" do
      ability.can?(:edit_document_place, Document).should be_true  # может изменит место хранения документа
      ability.should be_able_to(:edit_document_place, Document)
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)

    [Directive, Term, BproceBapp, BproceIresource, BusinessRole].each do |model|
      it "can :manage '#{model.to_s}'" do
        ability.should be_able_to(:create, model.new)
        ability.should be_able_to(:update, model.new)
        ability.should be_able_to(:destroy, model.new)
      end
    end
    [Document].each do |model|
      it "can :manage '#{model.to_s}'" do
        ability.should be_able_to(:create, model.new)
        ability.should be_able_to(:update, model.new)
      end
    end

    it "can :manage Bproce" do
      @bproce = FactoryGirl.create(:bproce)
      @bproce.user_id = @user.id
      user = @user
      #ability.should be_able_to(:update, @bproce, :user_id => @user.id)
    end

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
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
      @user.roles.count.should == 1
    end

    ability = Ability.new(@user)

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
    end
  end

end