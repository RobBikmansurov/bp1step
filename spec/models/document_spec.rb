# frozen_string_literal: true

require 'rails_helper'

describe Document do
  let(:owner)    { FactoryBot.create(:user, displayname: 'Bush') }
  let(:document) { FactoryBot.create(:document, owner_id: owner.id) }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:place) }
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_length_of(:name).is_at_least(10).is_at_most(200) }
    it { is_expected.to validate_numericality_of(:dlevel) }
  end

  context 'with associations' do
    # it { should belong_to(:bproce) }
    it { is_expected.to have_many(:bproce_document).dependent(:destroy) }
    it { is_expected.to belong_to(:owner).class_name(:User) }
    it { is_expected.to have_many(:directive).through(:document_directive) }
    it { is_expected.to have_many(:document_directive).dependent(:destroy) }
  end

  context 'when have_attached_file' do
    it { is_expected.to have_attached_file(:document_file) }
    it { is_expected.not_to validate_attachment_presence(:document_file) }
    it do
      is_expected.not_to validate_attachment_size(:document_file)
        .less_than(2.megabytes)
    end
  end

  it 'return short name' do
    document.name = '1234567890' * 6
    expect(document.shortname).to eq(('1234567890' * 5).to_s)
  end
  it 'set owner by owner`s name' do
    document.owner_name = 'Bush'
    expect(document.owner_name).to eq('Bush')
  end
  # it 'return document pdf_path' do
  #   expect(document.pdf_path).to eq('')
  # end
end
