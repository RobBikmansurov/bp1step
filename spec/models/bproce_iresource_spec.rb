require 'rails_helper'

describe BproceIresource do
  context 'validations' do
    it { should validate_presence_of(:bproce_id) }
    it { should validate_presence_of(:iresource_id) }
  end

  context "associations" do
    it { should belong_to(:bproce) }
    it { should belong_to(:iresource) }
  end

end
