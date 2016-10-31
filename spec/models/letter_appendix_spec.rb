require 'rails_helper'

RSpec.describe LetterAppendix, :type => :model do
  context "validates" do
    it { should validate_presence_of(:letter_id) }
  end

  context "associations" do
    it { should belong_to(:letter).class_name('Letter') }
  end

  context "have_attached_file" do
    it { should have_attached_file(:appendix) }
    it { should validate_attachment_presence(:appendix) }
  end

end