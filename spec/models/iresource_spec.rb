require 'spec_helper'

PublicActivity.enabled = false

describe Iresource do
  before(:each) do
    @iresource = create(:iresource)
  end

  context "validates" do
    it "is valid with valid attributes: name, delevel, bproce_id" do
      @iresource.should be_valid
    end

  	#validates :label, :uniqueness => true, :length => {:minimum => 3, :maximum => 20}
	it "is not valid if length of location < 3 or > 255" do   #validates :location, :length => {:minimum => 3, :maximum => 255}
      @iresource.location = "12"
      @iresource.should_not be_valid
      @iresource.location = "123"
      @iresource.should be_valid
      @iresource.location = "1234567890" * 25 + "123456"
      @iresource.should_not be_valid
      @iresource.location = "1234567890" * 25 + "12345"
      @iresource.should be_valid
    end
  end

  context "associations" do
	it "belong_to :user" do
      should belong_to(:user) # у ресурса может быть владелец
    end
  	#has_many :bproce_iresources
  	#has_many :bproces, :through => :bproce_iresources
  end

end
