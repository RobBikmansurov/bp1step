require 'spec_helper'

PublicActivity.enabled = false

describe Term do
  before(:each) do
    @term = create(:term)
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      @term.should be_valid
    end
    it "it require uniqueness shortname" do
      @term1 = create(:term, shortname: 'shortname')
      @term1.should be_valid
      @term2 = build(:term, shortname: 'shortname')
      @term2.should_not be_valid
    end
    it "is not valid if length of shortname > 20" do 	#::length => {:maximum => 20}
      @term.shortname = "1234567890" * 2 + "1"
      @term.should_not be_valid
      @term.shortname = "1234567890" * 2
      @term.should be_valid
    end
    it "is not valid without a name" do
      @term.name = nil
      @term.should_not be_valid
    end
    it "is not valid if length of name < 3 or > 200" do 	#:length => {:minimum => 3, :maximum => 200}
      @term.name = "12"
      @term.should_not be_valid
      @term.name = "123"
      @term.should be_valid
      @term.name = "1234567890" * 20 + "1"
      @term.should_not be_valid
      @term.name = "1234567890" * 20
      @term.should be_valid
    end

    it "is not valid without a description" do
      @term.description = nil
      @term.should_not be_valid
    end
  end

end
