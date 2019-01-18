# frozen_string_literal: true

require 'rails_helper'

describe Directive do
  let(:approval)   { Time.zone.parse('2019-01-01') }
  let(:directive)  { FactoryBot.create(:directive, title: 'Закон', number: '123-ФЗ', approval: approval, body: 'РФ') }

  context 'with validates' do
    it { is_expected.to validate_presence_of(:approval) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(10) }
    it { is_expected.to validate_length_of(:status).is_at_most(30) }
    it { is_expected.to validate_length_of(:body).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_length_of(:note).is_at_most(255) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:document).through(:document_directive) } # на основании директивы может быть несколько документов
    it { is_expected.to have_many(:document_directive).dependent(:destroy) }
  end

  context 'with approval date' do
    it 'return short name' do
      expect(directive.shortname).to eq('Закон 123-ФЗ от 01.01.2019')
    end
    it 'return middle name' do
      expect(directive.midname).to eq('Закон РФ №123-ФЗ 01.01.2019')
    end
    it 'return directive name' do
      expect(directive.directive_name).to eq("Закон РФ №123-ФЗ 01.01.2019   ##{directive.id}")
    end
  end
  context 'without approval date' do
    it 'return short name' do
      directive.approval = nil
      expect(directive.shortname).to eq('Закон 123-ФЗ')
    end
    it 'return middle name' do
      directive.approval = nil
      expect(directive.midname).to eq('Закон РФ №123-ФЗ')
    end
    it 'return directive name' do
      directive.approval = nil
      expect(directive.directive_name).to eq("Закон РФ №123-ФЗ   ##{directive.id}")
    end
  end
  it 'have search method' do
    expect(described_class.search('').first).to eq(described_class.first)
  end
end
