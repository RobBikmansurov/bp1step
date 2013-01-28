require "cancan/matchers"
require "spec_helper"
require 'factory_girl'

describe Ability do
  let(:guest) { Ability.new(user) }
  #let(:guest) { FactoryGirl.create(:user) }
  let(:any_document) { Document.new() }
  let(:paid_article) { Bapp.new() }

  context "guest user" do   # незарегистрированный пользователь
    let(:user) { nil }
    it "can :read any Objects" do
      guest.can?(:read, Bapp).should be_true
      guest.can?(:read, Bproce).should be_true
      guest.can?(:read, BproceBapp).should be_true
      guest.can?(:read, BproceWorkplace).should be_true
      guest.can?(:read, BusinessRole).should be_true
      guest.can?(:read, Directive).should be_true
      guest.can?(:read, Document).should be_true
      guest.can?(:read, Role).should be_true
      guest.can?(:read, User).should be_true
      guest.can?(:read, UserBusinessRole).should be_true
      guest.can?(:read, UserWorkplace).should be_true
      guest.can?(:read, Workplace).should be_true
    end
    it "cannot :manage any Objects" do
      guest.can?(:manage, Bapp).should be_false
      guest.can?(:manage, Bproce).should be_false
      guest.can?(:manage, BproceBapp).should be_false
      guest.can?(:manage, BproceWorkplace).should be_false
      guest.can?(:manage, BusinessRole).should be_false
      guest.can?(:manage, Directive).should be_false
      guest.can?(:manage, Document).should be_false
      guest.can?(:manage, Role).should be_false
      guest.can?(:manage, User).should be_false
      guest.can?(:manage, UserBusinessRole).should be_false
      guest.can?(:manage, UserWorkplace).should be_false
      guest.can?(:manage, Workplace).should be_false
    end
    it "cannot :show User" do
      guest.can?(:show, User).should be_false # не видит подробностей о пользователе
      guest.can?(:index, User).should be_true
    end
    it "can't assign roles" do
      guest.can?(:assign_roles, User).should be_false
    end
    it "can't view document" do
      guest.can?(:view_document, Document).should be_false
    end
  end

  let(:auth_user) { Ability.new(user) }
  context "authorized user" do
    let(:user) {FactoryGirl.create(:auth_user)}
    
    #it{ should be_able_to(:show, User) }
    it "can view document" do
      auth_user.can?(:view_document, Document).should be_true
    end
    it "can :show User" do
      auth_user.can?(:show, User).should be_true # видит подробностей о пользователе
      auth_user.can?(:index, User).should be_true
    end

  end

end