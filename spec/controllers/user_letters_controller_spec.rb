# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserLettersController, type: :controller do
  let(:user)             { FactoryBot.create(:user) }
  let(:author)           { FactoryBot.create(:user) }
  let!(:letter)            { FactoryBot.create(:letter, author_id: author.id) }
  let(:user_letter)        { FactoryBot.create(:user_letter, user_id: user.id, letter_id: letter.id) }
  let(:valid_attributes) { { user_id: user.id, letter_id: letter.id, status: 0 } }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET show' do
    it 'assigns the requested user_letter as @user_letter' do
      get :show, params: { id: user_letter.id.to_param }
      expect(assigns(:user_letter)).to eq(user_letter)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new UserLetter' do
        expect do
          post :create, params: { user_letter: valid_attributes }
        end.to change(UserLetter, :count).by(1)
      end

      it 'assigns a newly created user_letter as @user_letter' do
        post :create, params: { user_letter: valid_attributes }
        expect(assigns(:user_letter)).to be_a(UserLetter)
        expect(assigns(:user_letter)).to be_persisted
      end

      it 'redirects to the created user_letter' do
        post :create, params: { user_letter: valid_attributes }
        expect(response).to redirect_to(UserLetter.last)
      end
    end
  end
  describe 'DELETE destroy' do
    it 'destroys the requested user_letter' do
      user_letter = UserLetter.create! valid_attributes
      expect do
        delete :destroy, params: { id: user_letter.to_param }
      end.to change(UserLetter, :count).by(-1)
    end
  end
end
