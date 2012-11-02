require 'spec_helper'

describe Directive do
  before(:each) do
    @directive = Directive.new
    @directive.name = 'test_directive_name'
    @directive.title = 'test_directive_title'
    @directive.number = 'test_directive_number'
    @directive.note = 'test_directive_note'
    @directive.body = 'test_directive_body'
    @directive.annotation = 'test_directive_annotation'
  end

  it "should be valid" do
    @directive.should be_valid
  end

  it "should require name" do	#validates :name, :presence => true, :length => {:minimum => 10}
    @directive.name = "123456789"
    @directive.should_not be_valid
    @directive.name = "1234567890"
    @directive.should be_valid
  end

  it "should require number" do	#validates :number, :presence => true
    @directive.number = ""
    @directive.should_not be_valid
  end

  it "should require body" do  #validates :body, :length => {:minimum => 2, :maximum => 100}	# орган, утвердивший документ
    @directive.body = "1"
    @directive.should_not be_valid
    @directive.body = "12"
    @directive.should be_valid
    @directive.body = "a" * 100
    @directive.should be_valid
    @directive.body = "b" * 101
    @directive.should_not be_valid
  end

  it "should can have many documents" do	#has_many :document, :through => :document_directive
  											#has_many :document_directive, :dependent => :destroy
    @document = Document.create(:name => "TestDocument", :bproce_id => "1", :dlevel => "1")
    @directive.save
    @directive.document_directive.create(:document_id => @document)
    @directive.document_directive.count.should == 1
  end

end
