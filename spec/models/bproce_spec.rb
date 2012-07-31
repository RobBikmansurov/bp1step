require 'spec_helper'
describe Bproce do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @bp = Bproce.new
    @bp.name = "test_process_1"
  end
  
  it "should require name" do
    @bp.name = nil
    @bp.should_not be_valid
    #@bp.errors.on(:name).should_not be_nil
  end
end
