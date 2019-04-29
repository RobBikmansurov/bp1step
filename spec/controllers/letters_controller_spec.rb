# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LettersController, type: :controller do
  let(:valid_attributes) { { sender: 'sender', date: Date.current, subject: 'subject', number: '123', status: 90 } }
  let(:invalid_attributes) { { subject: 'invalid value' } }
  let(:valid_session) { {} }
  let(:author) { create :user }
  let(:user) { create :user }
  let(:letter) { create :letter, author: author }
  let(:letter1) { create :letter, author: author }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET index' do
    it 'assigns all letters as @letters' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('letters/index')
    end

    it 'loads all of the letters into @letters' do
      get :index
      expect(assigns(:letters)).to match_array([letter, letter1])
    end
    it 'loads letter for date' do
      letter_new = FactoryBot.create :letter, author_id: author.id, date: '2011-01-01'
      get :index, params: { date: '2011-01-01' }
      expect(assigns(:letters)).to match_array([letter_new])
    end
    it 'loads letter for regdate' do
      letter_new = FactoryBot.create :letter, author_id: author.id, regdate: '2011-01-01'
      get :index, params: { regdate: '2011-01-01' }
      expect(assigns(:letters)).to match_array([letter_new])
    end
    it 'loads letter for status' do
      letter_new = FactoryBot.create :letter, author_id: author.id, status: 90
      get :index, params: { status: 90 }
      expect(assigns(:letters)).to match_array([letter_new])
    end
    it 'loads letter for user' do
      user = FactoryBot.create :user
      letter_new = FactoryBot.create :letter, author_id: author.id
      user_letter = FactoryBot.create :user_letter, user_id: user.id, letter_id: letter_new.id
      get :index, params: { user: user.id }
      expect(assigns(:letters)).to match_array([letter_new])
    end
  end

  describe 'GET show' do
    it 'assigns the requested letter as @letter' do
      letter = Letter.create! valid_attributes
      get :show, params: { id: letter.to_param }
      expect(assigns(:letter)).to eq(letter)
    end
  end

  describe 'GET new' do
    it 'assigns a new letter as @letter' do
      get :new
      expect(assigns(:letter)).to be_a_new(Letter)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested letter as @letter' do
      letter = Letter.create! valid_attributes
      get :edit, params: { id: letter.to_param }
      expect(assigns(:letter)).to eq(letter)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Letter' do
        expect do
          post :create, params: { letter: valid_attributes }
        end.to change(Letter, :count).by(1)
      end

      it 'assigns a newly created letter as @letter' do
        post :create, params: { letter: valid_attributes }
        expect(assigns(:letter)).to be_a(Letter)
        expect(assigns(:letter)).to be_persisted
      end

      it 'redirects to the created letter' do
        post :create, params: { letter: valid_attributes }
        expect(response).to redirect_to(Letter.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved letter as @letter' do
        post :create, params: { letter: invalid_attributes }
        expect(assigns(:letter)).to be_a_new(Letter)
      end

      it "re-renders the 'new' template" do
        post :create, params: { letter: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested letter' do
        letter = create :letter, author: author, status: 0
        expect_any_instance_of(Letter).to receive(:save).at_least(:once)
        put :update, params: { id: letter.to_param, letter: valid_attributes }
      end

      it 'assigns the requested letter as @letter' do
        letter = Letter.create! valid_attributes
        put :update, params: { id: letter.to_param, letter: valid_attributes }
        expect(assigns(:letter)).to eq(letter)
      end

      it 'redirects to the letter' do
        letter = Letter.create! valid_attributes
        put :update, params: { id: letter.to_param, letter: valid_attributes }
        expect(response).to redirect_to(letter)
      end
    end

    describe 'with invalid params' do
      it 'assigns the letter as @letter' do
        letter = Letter.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, params: { id: letter.to_param, letter: invalid_attributes }
        expect(assigns(:letter)).to eq(letter)
      end

      it "re-renders the 'edit' template" do
        letter = Letter.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, params: { id: letter.to_param, letter: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested letter' do
      letter = Letter.create! valid_attributes
      expect do
        delete :destroy, params: { id: letter.to_param }
      end.to change(Letter, :count).by(-1)
    end

    it 'redirects to the letters list' do
      letter = Letter.create! valid_attributes
      delete :destroy, params: { id: letter.to_param }
      expect(response).to redirect_to(letters_url)
    end
  end

  describe 'update_user' do
    it 'save user and show letter' do
      user = create :user
      user_letter = create :user_letter, user_id: user.id, letter_id: letter.id
      put :update_user, params: { id: letter.to_param,
                                  user_letter: { user_id: user.id, letter_id: letter.id, status: 0, user_name: user.displayname } }
      expect(assigns(:letter)).to eq(letter)
    end
  end

  it 'clone letter' do
    get :clone, params: { id: letter.id}
    expect(response).to render_template('clone')
  end
  it 'create outgoing letter' do
    get :create_outgoing, params: { id: letter.id}
    expect(response).to render_template :create_outgoing
  end
  it 'create task' do
    get :create_task, params: { id: letter.id }
    expect(response).to redirect_to "/tasks/new?letter_id=#{letter.id}"
  end
  it 'create requirement' do
    get :create_requirement, params: { id: letter.id }
    expect(response).to redirect_to "/requirements/new?letter_id=#{letter.id}"
  end

  it 'register letter' do
    letter.update_column :letter_id, letter1.id
    letter.update_column :in_out, 2
    get :register, params: { id: letter.id }
    expect(response).to redirect_to "/letters/#{letter.id}?letter_id=#{letter.id}"
  end

  it 'display sender list' do
    get :senders
    expect(response).to render_template :senders
  end
  it 'display sender list with status' do
    get :senders, params: { status: 90 }
    expect(response).to render_template :senders
  end

  describe 'reports' do
    it 'render report check' do
      current_user = FactoryBot.create :user
      user = create :user
      user_letter = create :user_letter, user: user, letter: letter
      get :check, params: { id: letter.to_param }
      expect(response).to be_successful
    end
    it 'render week report' do
      current_user = FactoryBot.create :user
      letter1 = create :letter, author: user, regdate: Date.current - 5
      letter2 = create :letter, author: user, regdate: Date.current - 5
      get :log_week, params: { week_day: Date.current - 5 }
      expect(response).to be_successful
    end
    it 'render reestr report' do
      current_user = FactoryBot.create :user
      get :reestr, params: { id: letter.id }
      expect(response).to be_successful
    end
  end
end
