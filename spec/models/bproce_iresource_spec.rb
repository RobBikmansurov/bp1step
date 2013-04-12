require 'spec_helper'

PublicActivity.enabled = false

describe BproceIresource do
  before(:each) do
  	@bproce_iresource = create (:bproce_iresource)
  end

  context "validates" do
    it "is valid with valid attributes" do
      @bproce_iresource.should be_valid
    end 

    it "should require bproce_id" do
      @bproce_iresource.bproce_id = nil
      @bproce_iresource.should_not be_valid
    end 

    it "should require iresource_id" do
      @bproce_iresource.iresource_id = nil
      @bproce_iresource.should_not be_valid
    end 

  end

end
