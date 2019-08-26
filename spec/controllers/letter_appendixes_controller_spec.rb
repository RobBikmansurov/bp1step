# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LetterAppendixesController do
  let(:user) { FactoryBot.create :user }
  let(:letter) { FactoryBot.create(:letter, author_id: user.id) }
  let!(:letter_appendix) { create :letter_appendix, letter_id: letter.id }

  before do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'assigns the requested letter as @letter' do
        put :update, params: { id: letter_appendix.to_param,
                               letter_appendix: { name: 'text' } }
        expect(assigns(:letter)).to eq(letter)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to the letters list' do
      letter_appendix = create :letter_appendix, letter_id: letter.id
      delete :destroy, params: { id: letter_appendix.to_param }
      expect(response).to redirect_to letter
    end
  end
end
