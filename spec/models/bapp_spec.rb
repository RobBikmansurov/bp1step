require 'spec_helper'

describe Bapp do
  context "validates" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should ensure_length_of(:name).is_at_least(4).is_at_most(50) }
    it { should validate_presence_of(:description) }
  end

  context "associations" do
    it { should have_many(:bproce_bapps) }
    it { should have_many(:bproces).through(:bproce_bapps) }
  end

end
