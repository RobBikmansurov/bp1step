# frozen_string_literal: true
require 'rails_helper'

describe Directive do
  context 'validates' do
    it { should validate_presence_of(:approval) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(10) }
    it { should validate_length_of(:status).is_at_most(30) }
    it { should validate_length_of(:body).is_at_least(2).is_at_most(100) }
    it { should validate_length_of(:note).is_at_most(255) }
  end

  context 'associations' do
    it { should have_many(:document).through(:document_directive) } # на основании директивы может быть несколько документов
    it { should have_many(:document_directive).dependent(:destroy) }
  end
end
