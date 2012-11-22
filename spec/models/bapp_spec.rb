require 'spec_helper'

describe Bapp do
  before(:each) do
    @bapp = Bapp.new
    @bapp.name = 'test_name'
    @bapp.description='test_description'
    @bapp.save
  end

  context "validates" do
    it "is valid with valid attributes: name, description" do
      @bapp.should be_valid
    end

    it "is not valid without a name" do
      @bapp.name = nil
      @bapp.should_not be_valid
    end
    it "it require uniqueness name" do
      @bapp1 = Bapp.new
      @bapp1.name = "test_name"
      @bapp1.description='test_description'
      @bapp1.should_not be_valid
      @bapp1.save
      @bapp2 = Bapp.new
      @bapp2.name = "test_name2"
      @bapp2.description='test_description'
      @bapp2.should be_valid
      @bapp2.save
    end
    it "is not valid if length of title < 6" do
      @bapp.name = "short"
      @bapp.should_not be_valid
    end
    it "is not valid if length of title > 50" do
      @bapp.name = "maxlenght1maxlenght2maxlenght3maxlenght4maxlenght5_"
      @bapp.should_not be_valid
    end
    it "is not valid without a description" do
      @bapp.description = nil
      @bapp.should_not be_valid
    end
  end

  context "associations" do
    it "has_many :bproce_bapps" do
      should have_many(:bproce_bapps) #приложение относится ко многим процессам
    end
    it "has_many :bproces, :through => :bproce_bapps" do
      should have_many(:bproces).through(:bproce_bapps) #приложение относится ко многим процессам
    end
  end

end
