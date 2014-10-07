require 'spec_helper'

describe BproceIresource do
  before(:each) do
  	@bproce_iresource = create (:bproce_iresource)
  end

  context "validates" do
    it "is valid with valid attributes" do
      expect(@bproce_iresource).to be_valid
    end 

    it "should require bproce_id" do
      expect(@bproce_iresource.bproce_id).not_to be_nil
      expect(@bproce_iresource).to be_valid
    end 

    it "should require iresource_id" do
      expect(@bproce_iresource.iresource_id).not_to be_nil
      expect(@bproce_iresource).to be_valid
    end 

  end

end
