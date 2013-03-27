require 'spec_helper'

PublicActivity.enabled = false

describe DocumentDirective do
  before(:each) do
    @document_directive = DocumentDirective.create(:document_id => 1, :directive_id => 1)
    @document_directive.note = 'test_document_directive_note'
  end

  it "should be valid" do
    @document_directive.should be_valid
  end

  it "should be belongs_to :directive" do 	# belongs_to :directive
  	@document_directive.directive_id = nil
    @document_directive.should_not be_valid
  end

  it "should be belongs_to :document" do 	# belongs_to :document
  	@document_directive.document_id = nil
    @document_directive.should_not be_valid
  end

end
