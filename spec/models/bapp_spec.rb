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
  it "should require uniqueness name" do
    @bapp1 = Bapp.new
    @bapp1.name = "test_name"
    @bapp1.should_not be_valid
  end
  it "should require long name" do
    @bapp.name = "short"
    @bapp.should_not be_valid
  end
  it "should require max lenght name 50" do
    @bapp.name = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
    @bapp.should_not be_valid
  end
  it "should require description" do
    @bapp.description = nil
    @bapp.should_not be_valid
  end

end
