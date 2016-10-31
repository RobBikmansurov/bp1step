require 'rails_helper'

describe Requirement do

  context "validates" do
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_length_of(:label).is_at_least(3).is_at_most(255) }
  end

  context "associations" do
    it { should belong_to(:letter) }
    it { should belong_to(:author) }
    it { should have_many(:user) }
    it { should have_many(:user_requirement).dependent(:destroy) }
    it { should have_many(:task) }
  end
end
