# frozen_string_literal: true

RSpec.describe BproceIresourcesController, type: :controller do
  let(:valid_attributes) { { bproce_id: '1', iresource_id: '1', rpurpose: 'Purpose' } }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested bproce_iresource as @bproce_iresource' do
      bproce_iresource = BproceIresource.create! valid_attributes
      get :show, { id: bproce_iresource.to_param }, valid_session
      expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
    end
  end

  describe 'GET new' do
    it 'assigns a new bproce_iresource as @bproce_iresource' do
      get :new, {}, valid_session
      expect(assigns(:bproce_iresource)).to be_a_new(BproceIresource)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested bproce_iresource as @bproce_iresource' do
      bproce_iresource = BproceIresource.create! valid_attributes
      get :edit, { id: bproce_iresource.to_param }, valid_session
      expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new BproceIresource' do
        expect do
          post :create, { bproce_iresource: valid_attributes }, valid_session
        end.to change(BproceIresource, :count).by(1)
      end

      it 'assigns a newly created bproce_iresource as @bproce_iresource' do
        post :create, { bproce_iresource: valid_attributes }, valid_session
        expect(assigns(:bproce_iresource)).to be_a(BproceIresource)
        expect(assigns(:bproce_iresource)).to be_persisted
      end

      it 'redirects to the created bproce_iresource' do
        post :create, { bproce_iresource: valid_attributes }, valid_session
        expect(response).to redirect_to(BproceIresource.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved bproce_iresource as @bproce_iresource' do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        post :create, { bproce_iresource: {} }, valid_session
        expect(assigns(:bproce_iresource)).to be_a_new(BproceIresource)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        post :create, { bproce_iresource: {} }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested bproce_iresource' do
        bproce_iresource = BproceIresource.create! valid_attributes
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, { id: bproce_iresource.to_param, bproce_iresource: { 'these' => 'params' } }, valid_session
      end

      it 'assigns the requested bproce_iresource as @bproce_iresource' do
        bproce_iresource = BproceIresource.create! valid_attributes
        put :update, { id: bproce_iresource.to_param, bproce_iresource: valid_attributes }, valid_session
        expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
      end

      it 'redirects to the bproce_iresource' do
        bproce_iresource = BproceIresource.create! valid_attributes
        put :update, { id: bproce_iresource.to_param, bproce_iresource: valid_attributes }, valid_session
        expect(response).to redirect_to(bproce_iresource)
      end
    end

    describe 'with invalid params' do
      it 'assigns the bproce_iresource as @bproce_iresource' do
        bproce_iresource = BproceIresource.create! valid_attributes
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, { id: bproce_iresource.to_param, bproce_iresource: {} }, valid_session
        expect(assigns(:bproce_iresource)).to eq(bproce_iresource)
      end

      it "re-renders the 'edit' template" do
        bproce_iresource = BproceIresource.create! valid_attributes
        expect_any_instance_of(BproceIresource).to receive(:save).and_return(false)
        put :update, { id: bproce_iresource.to_param, bproce_iresource: {} }, valid_session
        expect(response).to_not render_template('edit')
      end
    end
  end
end
