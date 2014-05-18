require 'spec_helper'

describe BproceContract do
  PublicActivity.enabled = false

  context "associations" do
    it { should belong_to(:bproce) }
    it { should belong_to(:contract) }
  end

end
