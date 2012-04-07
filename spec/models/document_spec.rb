require 'spec_helper'

describe Document do
  before(:each) do
    @doc = Document.new
    @doc.name = 'test_doc_name'
  end
  it "should be valid" do
    @doc.should be_valid
  end
  it "should require name" do
    @doc.name = "12"
    @doc.should_not be_valid
  end
end
