# frozen_string_literal: true

require 'rails_helper'

describe DocumentDirective do
  let(:user)               { FactoryBot.create(:user) }
  let(:document)           { FactoryBot.create(:document, owner_id: user.id) }
  let(:directive)          { FactoryBot.create :directive }
  let(:document0)          { FactoryBot.create(:document, owner_id: user.id) }
  let(:directive0)         { FactoryBot.create :directive }
  let(:document_directive) { FactoryBot.create :document_directive, document_id: document0.id, directive_id: directive0.id }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:document_id) }
    it { is_expected.to validate_presence_of(:directive_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:document) }
    it { is_expected.to belong_to(:directive) }
  end

  context 'with methods' do
    it 'set document by name' do
      document_directive.document_name = document.name
      expect(document_directive.document_name).to eq(document.name)
    end

    it 'set directive by number' do
      document_directive.directive_number = "  ##{directive.id}"
      expect(document_directive.directive_number).to eq(directive.name)
    end
  end
end
