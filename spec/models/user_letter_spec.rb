require 'rails_helper'

describe UserLetter do
  context "validates" do
    it { should validate_presence_of(:letter) }
    it { should validate_presence_of(:user) }
  end

  context "associations" do
    it { should belong_to(:letter) }
    it { should belong_to(:user) }
  end
end