# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserDocumentsController, type: :controller do
  let(:owner) { create(:user) }
  let(:document) { create :document, owner_id: owner.id }

  before do
    @user = create :user
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'DELETE destroy' do
    it 'destroys the requested user_document' do
      UserDocument.create user_id: @user.id, document_id: document.id
      expect do
        delete :destroy, params: { id: document.to_param }
      end.to change(UserDocument, :count).by(-1)
    end
  end
end
