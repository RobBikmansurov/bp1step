require 'rails_helper'

describe Bproce do

  context "validates" do
    it { should validate_presence_of(:name) }
    #it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(10).is_at_most(250) }
    it { should validate_presence_of(:shortname) }
    #it { should validate_uniqueness_of(:shortname) }
    it { should validate_length_of(:shortname).is_at_least(1).is_at_most(50) }
    it { should validate_length_of(:fullname).is_at_least(10).is_at_most(250) }
  end

  context "associations" do
    it { should have_many(:documents) }
    it { should have_many(:business_roles).dependent(:destroy) }
    it { should have_many(:bproce_workplaces).dependent(:destroy) }
    it { should have_many(:workplaces).through(:bproce_workplaces) }
    it { should have_many(:bproce_iresource).dependent(:destroy) }
    it { should have_many(:iresource).through(:bproce_iresource) }
    it { should have_many(:bproce_bapps).dependent(:destroy) }
    it { should have_many(:bapps).through(:bproce_bapps).dependent(:destroy) }
    it { should have_many(:bproce_documents).dependent(:destroy) }
    it { should have_many(:bproce_documents).dependent(:destroy) }
    it { should belong_to(:bproce) }  # процесс может имет родительский процесс
    it { should belong_to(:user) }  # владелец процессв
  end

end
