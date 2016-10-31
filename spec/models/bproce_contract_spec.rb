require 'rails_helper'

describe BproceContract do
  context "associations" do
    it { should belong_to(:bproce) }
    it { should belong_to(:contract) }
  end

end
