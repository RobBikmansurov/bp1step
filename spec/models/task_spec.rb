require 'spec_helper'

describe Task do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(5).is_at_most(255) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:duedate) }
  end

  context "associations" do
    it { should belong_to(:letter) }
    it { should belong_to(:requirement) }
    it { should belong_to(:author) }
    it { should have_many(:user_task).dependent(:destroy) }
  end
end
