require 'spec_helper'

describe Letter do
  context "validates" do
    it { should validate_presence_of(:subject) }
    it { should ensure_length_of(:subject).is_at_least(3).is_at_most(200) }
  end

  context "associations" do
  	it { should belong_to(:letter).class_name('Letter')}
    it { should have_many(:user_letter).dependent(:destroy) }
    it { should have_many(:letter_appendix).dependent(:destroy) }
  end
end
