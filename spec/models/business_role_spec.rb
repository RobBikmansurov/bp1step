require 'rails_helper'

describe BusinessRole do

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:bproce_id) }
  end

  context "associations" do
    it { should belong_to(:bproce) }
    it { should have_many(:user_business_role).dependent(:destroy) }
    it { should have_many(:users).through(:user_business_role) }#приложение относится ко многим процессам
  end

end
