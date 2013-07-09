require "cancan/matchers"
require "spec_helper"

PublicActivity.enabled = false

User.all.each do |u|
  u.delete
end
Role.all.each do |r|
  r.delete
end
UserRole.all.each do |ur|
  ur.delete
end

user = FactoryGirl.create(:user)
describe Ability do
  context "unauthorized user or user without roles" do   # незарегистрированный пользователь
    ability = Ability.new(user)
    [Bapp, Bproce, BproceBapp, BusinessRole, Directive, Document, Role, Workplace].each do |model|
      it "can :read '#{model.to_s}' but can't :manage them" do
        ability.should be_able_to(:read, model.new)
        ability.should_not be_able_to(:manage, FactoryGirl.create(model.to_s.underscore.to_sym))
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
  end

  context "authorized user with role :user" do   # зарегистрированный пользователь с ролью Пользователь
    role = FactoryGirl.create(:role)
    role.name = :user
    user_role = UserRole.new
    user_role.user_id = user.id
    user_role.role_id = role.id
    user_role.save

    it "has roles" do
      user.roles.count.should == 1
    end

    ability = Ability.new(user)

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
    role.name = :author
    role.save

    it "has roles" do
      user.roles.count.should == 1
    end

    ability = Ability.new(user)

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
    end
  end

  context "authorized user with role :owner" do   # Владелец процесса
    role = Role.first
    role.name = :owner
    role.save

    it "has roles" do
      user.roles.count.should == 1
    end

    ability = Ability.new(user)

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
    role.name = :analitic
    role.save

    it "has roles" do
      user.roles.count.should == 1
    end

    ability = Ability.new(user)

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
    role.name = :admin
    role.save

    it "has roles" do
      user.roles.count.should == 1
    end

    ability = Ability.new(user)

    it "can view Document" do
      ability.can?(:view_document, Document).should be_true  # может просмотреть файл документа
      ability.should be_able_to(:view_document, Document)   # может просмотреть файл документа
    end
    it "can :show User" do
      ability.should be_able_to(:read, User)
      ability.can?(:show, User).should be_true # видит подробностей о пользователе
    end
  end

  #UserRole.first.delete
  #Role.first.delete

end