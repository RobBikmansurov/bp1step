# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LetterAppendixesController, type: :controller do
  let(:letter) { FactoryBot.create :letter }
  let(:valid_attributes) { { letter_id: letter.id, appendix_file_name: 'afn', appendix_file_size: 123 } }
  let(:invalid_attributes) { { subject: 'invalid value' } }
  let(:valid_session) { {} }
  let(:letter_appendix) { FactoryBot.create :letter_appendix }
  let(:letter_appendix1) { FactoryBot.create :letter_appendix }

  before(:each) do
    @user = FactoryBot.create(:user)
    @user.roles << Role.find_or_create_by(name: 'author', description: 'Автор')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested letter_appendix' do
        letter_appendix = LetterAppendix.create! valid_attributes
        expect_any_instance_of(LetterAppendix).to receive(:save).at_least(:once)
        put :update, params: { id: letter_appendix.to_param, letter_appendix: valid_attributes }
      end

      it 'assigns the requested letter_appendix as @letter_appendix' do
        letter_appendix = LetterAppendix.create! valid_attributes
        put :update, params: { id: letter_appendix.to_param, letter_appendix: valid_attributes }
        expect(assigns(:letter)).to eq(letter)
      end

      it 'redirects to the letter_appendix' do
        letter_appendix = LetterAppendix.create! valid_attributes
        put :update, params: { id: letter_appendix.to_param, letter_appendix: valid_attributes }
        expect(response).to redirect_to(letter)
      end
    end

    describe 'with invalid params' do
      it 'assigns the letter_appendix as @letter_appendix' do
        letter_appendix = LetterAppendix.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, params: { id: letter_appendix.to_param, letter_appendix: invalid_attributes }
        expect(assigns(:letter_appendix)).to eq(letter_appendix)
      end

      it "re-renders the 'edit' template" do
        letter_appendix = LetterAppendix.create! valid_attributes
        expect_any_instance_of(Letter).to receive(:save).and_return(false)
        put :update, params: { id: letter_appendix.to_param, letter_appendix: invalid_attributes }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested letter_appendix' do
      letter_appendix = LetterAppendix.create! valid_attributes
      expect do
        delete :destroy, params: { id: letter_appendix.to_param }
      end.to change(Letter, :count).by(-1)
    end

    it 'redirects to the letter_appendixs list' do
      letter_appendix = LetterAppendix.create! valid_attributes
      delete :destroy, params: { id: letter_appendix.to_param }
      expect(response).to redirect_to(letter_url)
    end
  end
end
