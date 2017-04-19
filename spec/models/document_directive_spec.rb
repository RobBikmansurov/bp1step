# frozen_string_literal: true

require 'rails_helper'

describe DocumentDirective do
  context 'validations' do
    it { should validate_presence_of(:document_id) }
    it { should validate_presence_of(:directive_id) }
  end

  context 'associations' do
    it { should belong_to(:document) }
    it { should belong_to(:directive) }
  end
end
