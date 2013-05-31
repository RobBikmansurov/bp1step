require 'spec_helper'

PublicActivity.enabled = false

describe BproceBapp do
  context 'validations' do
    it { should validate_presence_of(:bproce_id) }
    it { should validate_presence_of(:bapp_id) }
    it { should validate_presence_of(:apurpose) }
  end

  context "associations" do
    it { should belong_to(:bproce) }
    it { should belong_to(:bapp) }
  end

end
