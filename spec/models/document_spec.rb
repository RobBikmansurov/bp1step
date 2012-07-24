require 'spec_helper'

describe Document do
  before(:each) do
    @doc = Document.new
    @doc.name = 'test_doc_name'
    @doc.bproce_id = 1
    @doc.dlevel = 1
  end

  it "should be valid" do
    @doc.should be_valid
  end

  it "should require name" do
    @doc.name = "short"
    @doc.should_not be_valid
  end
  it "should require dlevel <= 4" do
    @doc.dlevel = 4
    @doc.should be_valid
  end
  it "should require dlevel < 5" do
    @doc.dlevel = 5
    @doc.should_not be_valid
  end
  it "should require dlevel >= 1" do
    @doc.dlevel = 1
    @doc.should be_valid
  end
  it "should require dlevel > 0" do
    @doc.dlevel = 0
    @doc.should_not be_valid
  end
end
