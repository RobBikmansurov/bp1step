# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LettersController, type: :controller do
  let(:valid_attributes) do
    { name: 'letter name', sender: 'sender', date: Date.current,
      subject: 'subject', number: '123', status: 0 }
  end
  let(:invalid_attributes) { { name: 'invalid value' } }
  let(:valid_session) { {} }
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all letters as @letters' do
      get :index, {}, valid_session
      expect(response).to be_success
      expect(response).to have_http_status(:success)
      expect(response).to render_template('letters/index')
    end

    it 'loads all of the letters into @letters' do
      letter1 = Letter.create! valid_attributes
      letter2 = Letter.create! valid_attributes
      get :index
      expect(assigns(:letters)).to match_array([letter1, letter2])
    end
  end

  describe 'GET show' do
    it 'assigns the requested letter as @letter' do
      letter = Letter.create! valid_attributes
      get :show, { id: letter.to_param }, valid_session
      expect(assigns(:letter)).to eq(letter)
    end
  end

  describe 'GET new' do
    it 'assigns a new letter as @letter' do
      get :new, valid_session
      expect(assigns(:letter)).to be_a_new(Letter)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested letter as @letter' do
      letter = Letter.create! valid_attributes
      get :edit, { id: letter.to_param }, valid_session
      expect(assigns(:letter)).to eq(letter)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Letter' do
        expect do
          post :create, { letter: valid_attributes }, valid_session
        end.to change(Letter, :count).by(1)
      end

      it 'assigns a newly created letter as @letter' do
        post :create, { letter: valid_attributes }, valid_session
        expect(assigns(:letter)).to be_a(Letter)
        expect(assigns(:letter)).to be_persisted
      end

      it 'redirects to the created letter' do
        post :create, { letter: valid_attributes }, valid_session
        expect(response).to redirect_to(Letter.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved letter as @letter' do
        post :create, { letter: invalid_attributes }, valid_session
        expect(assigns(:letter)).to be_a_new(Letter)
      end

      it "re-renders the 'new' template" do
        post :create, { letter: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested letter' do
        letter = Letter.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).at_least(:once)
        put :update, { id: letter.to_param, letter: valid_attributes }, valid_session
      end

      it 'assigns the requested letter as @letter' do
        letter = Letter.create! valid_attributes
        put :update, { id: letter.to_param, letter: valid_attributes }, valid_session
        expect(assigns(:letter)).to eq(letter)
      end

      it 'redirects to the letter' do
        letter = Letter.create! valid_attributes
        put :update, { id: letter.to_param, letter: valid_attributes }, valid_session
        expect(response).to redirect_to(letter)
      end
    end

    describe 'with invalid params' do
      it 'assigns the letter as @letter' do
        letter = Letter.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, { id: letter.to_param, letter: invalid_attributes }, valid_session
        expect(assigns(:letter)).to eq(letter)
      end

      it "re-renders the 'edit' template" do
        letter = Letter.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, { id: letter.to_param, letter: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested letter' do
      letter = Letter.create! valid_attributes
      expect do
        delete :destroy, { id: letter.to_param }, valid_session
      end.to change(Letter, :count).by(-1)
    end

    it 'redirects to the letters list' do
      letter = Letter.create! valid_attributes
      delete :destroy, { id: letter.to_param }, valid_session
      expect(response).to redirect_to(letters_url)
    end
  end
end
