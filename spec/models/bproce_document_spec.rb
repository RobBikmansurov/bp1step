require 'spec_helper'

describe BproceDocument do
  PublicActivity.enabled = false

  context "associations" do
    it { should belong_to(:bproce) }
    it { should belong_to(:document) }
  end

end
