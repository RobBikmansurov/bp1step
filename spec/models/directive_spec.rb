# frozen_string_literal: true

require 'rails_helper'

describe Directive do
  let(:directive)  { FactoryBot.create(:directive, title: 'Закон', number: '123-ФЗ', approval: Time.parse('2019-01-01'), body: 'РФ') }
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

  context 'methods' do
    it 'return short name' do
      expect(directive.shortname).to eq('Закон 123-ФЗ от 01.01.2019')
      directive.approval = nil
      expect(directive.shortname).to eq('Закон 123-ФЗ')
    end
    it 'return middle name' do
      expect(directive.midname).to eq('Закон РФ №123-ФЗ 01.01.2019')
      directive.approval = nil
      expect(directive.midname).to eq('Закон РФ №123-ФЗ')
    end
    it 'return directive name' do
      expect(directive.directive_name).to eq("Закон РФ №123-ФЗ 01.01.2019   ##{directive.id}")
      directive.approval = nil
      expect(directive.directive_name).to eq("Закон РФ №123-ФЗ   ##{directive.id}")
    end
  end
end
