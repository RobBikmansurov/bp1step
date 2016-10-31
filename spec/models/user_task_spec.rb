require 'rails_helper'

RSpec.describe UserTask, type: :model do
  context "validates" do
    it { should validate_presence_of(:task) }
    it { should validate_presence_of(:user) }
  end

  context "associations" do
    it { should belong_to(:task) }
    it { should belong_to(:user) }
  end
end