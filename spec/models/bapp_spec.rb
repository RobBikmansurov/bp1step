require 'spec_helper'

describe Bapp do
  before(:each) do
    @bapp = Bapp.new
    @bapp.name = 'test_name'
    @bapp.description='test_description'
  end

  it "should be valid" do
    @bapp.should be_valid
  end

  it "should require name" do
    @bapp.name = nil
    @bapp.should_not be_valid
#    @bapp.errors.on(:name).should_not be_nil
  end

end
