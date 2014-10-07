require 'spec_helper'

describe Term do
  before(:each) do
    @term = create(:term)
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      expect(@term).to be_valid
    end
    it "it require uniqueness shortname" do
      @term1 = create(:term, shortname: 'shortname')
      expect(@term1).to be_valid
      @term2 = build(:term, shortname: 'shortname')
      expect(@term2).not_to be_valid
    end
    it "is not valid if length of shortname > 20" do 	#::length => {:maximum => 20}
      @term.shortname = "1234567890" * 2 + "1"
      expect(@term).not_to be_valid
      @term.shortname = "1234567890" * 2
      expect(@term).to be_valid
    end
    it "is not valid without a name" do
      @term.name = nil
      expect(@term).not_to be_valid
    end
    it "is not valid if length of name < 3 or > 200" do 	#:length => {:minimum => 3, :maximum => 200}
      @term.name = "12"
      expect(@term).not_to be_valid
      @term.name = "123"
      expect(@term).to be_valid
      @term.name = "1234567890" * 20 + "1"
      expect(@term).not_to be_valid
      @term.name = "1234567890" * 20
      expect(@term).to be_valid
    end

    it "is not valid without a description" do
      @term.description = nil
      expect(@term).not_to be_valid
    end
  end

end
