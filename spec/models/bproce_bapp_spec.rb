require 'spec_helper'

describe BproceBapp do
  before(:each) do
    @bpbap = BproceBapp.new
    @bpbap.apurpose = "purpose_1"
  end
  
  it "should require purpose" do
    @bpbap.apurpose = nil
    @bpbap.should_not be_valid
  end
end
