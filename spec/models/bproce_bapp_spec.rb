require 'spec_helper'

PublicActivity.enabled = false

describe BproceBapp do
  before(:each) do
    @bpbap = create(:bproce_bapp)
  end
  context "validates" do
    it "is valid with valid attributes" do
      @bpbap.should be_valid
    end 
    it "should require bproce_id" do
      @bpbap.bproce_id = nil
      @bpbap.should_not be_valid
    end 
    it "should require bapp_id" do
      @bpbap.bapp_id = nil
      @bpbap.should_not be_valid
    end 
    it "should require purpose" do
      @bpbap.apurpose = nil
      @bpbap.should_not be_valid
    end
  end

  context "associations" do
    it "belongs_to :bproce" do
      should belong_to(:bproce) #приложение относится ко многим процессам
    end
    it "belongs_to :bapp" do
      should belong_to(:bapp) #приложение относится ко многим процессам
    end
  end

end
