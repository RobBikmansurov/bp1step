# frozen_string_literal: true
require 'rails_helper'
RSpec.describe BproceWorkplacesController, type: :controller do
  let(:owner)            { FactoryGirl.create(:user) }
  let(:role)             { FactoryGirl.create(:role, name: 'author', description: 'Автор' ) }
  let!(:bproce)          { FactoryGirl.create(:bproce) }
  let!(:workplace)       { FactoryGirl.create(:workplace) }
  let(:valid_attributes) { { bproce_id: bproce.id, workplace_id: workplace.id } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET show" do
    it "assigns the requested bproce_workplace.workplace as @workplace" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      get :show, {id: bproce_workplace.bproce.id.to_param}, valid_session
      expect(assigns(workplace)).to eq(bproce_workplace.workplace)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceWorkplace" do
        expect {
          post :create, {:bproce_workplace => valid_attributes}, valid_session
        }.to change(BproceWorkplace, :count).by(1)
      end

      it "assigns a newly created bproce_workplace as @bproce_workplace" do
        post :create, {:bproce_workplace => valid_attributes}, valid_session
        expect(assigns(:bproce_workplace)).to be_a(BproceWorkplace)
        expect(assigns(:bproce_workplace)).to be_persisted
      end

      it "redirects to the created bproce_workplace" do
        post :create, {:bproce_workplace => valid_attributes}, valid_session
        expect(response).to redirect_to(BproceWorkplace.last.workplace)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_workplace as @bproce_workplace" do
        expect_any_instance_of(BproceWorkplace).to receive(:save).and_return(false)
        post :create, {:bproce_workplace => {  }}, valid_session
        expect(assigns(:bproce_workplace)).to be_a_new(BproceWorkplace)
      end

    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce_workplace" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      bproce = create(:bproce)
      workplace = create(:workplace)
      bproce_workplace.bproce_id = bproce.id
      bproce_workplace.workplace_id = workplace.id
      expect {
        delete :destroy, {:id => bproce_workplace.to_param, :bproce_id => bproce.to_param}, valid_session
      }.to change(BproceWorkplace, :count).by(-1)
    end

    it "redirects to the bproce_workplaces list" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      delete :destroy, {:id => bproce_workplace.to_param}, valid_session
      expect(response).to redirect_to workplace_url
    end
  end

end
