require 'spec_helper'
describe Bproce do
    before(:each) do
    @bp = create(:bproce)
  end
  
  context "validates" do
    it "is valid with valid attributes: name, shortname, fullname" do
      @bp.should be_valid
    end
    it "is not valid without a name" do #validates :name, :uniqueness => true, :length => {:minimum => 10, :maximum => 250}
      @bp.name = nil
      @bp.should_not be_valid
    end
    it "it require uniqueness name" do
      @bp1 = create(:bproce, name: 'test_process1', shortname: "tst1")
      @bp1.should be_valid
      @bp1.name = 'test_process'
      @bp1.should_not be_valid
      @bp2 = create(:bproce, name: 'test_process2', shortname: "tst2")
      @bp2.should be_valid
    end
    it "is not valid if length of name < 10 or > 250" do
      @bp.name = "123456789"
      @bp.should_not be_valid
      @bp.name = "1234567890"
      @bp.should be_valid
      @bp.name = "1234567890" * 25 + "1"
      @bp.should_not be_valid
      @bp.name = "1234567890" * 25 
      @bp.should be_valid
    end

    it "is not valid without a shortname" do # validates :shortname, :uniqueness => true, :length => {:minimum => 3, :maximum => 50}
      @bp.shortname = nil
      @bp.should_not be_valid
    end
    it "it require uniqueness shortname" do
      @bp1 = create(:bproce, name: 'test_process1', shortname: "tst1")
      @bp1.should be_valid
      @bp1.shortname = 'TstPrc'
      @bp1.should_not be_valid
      @bp2 = create(:bproce, name: 'test_process2', shortname: "tst2")
      @bp2.should be_valid
    end
    it "is not valid if length of shortname < 3 or > 50" do
      @bp.shortname = "12"
      @bp.should_not be_valid
      @bp.shortname = "123"
      @bp.should be_valid
      @bp.shortname = "1234567890" * 5 + "1"
      @bp.should_not be_valid
      @bp.shortname = "1234567890" * 5 
      @bp.should be_valid
    end
    
    it "is not valid without a fullname" do # validates :fullname, :length => {:minimum => 10, :maximum => 250}
      @bp.fullname = nil
      @bp.should_not be_valid
    end
    it "is not valid if length of fullname < 10 or > 250" do
      @bp.fullname = "123456789"
      @bp.should_not be_valid
      @bp.fullname = "1234567890"
      @bp.should be_valid
      @bp.fullname = "1234567890" * 25 + "1"
      @bp.should_not be_valid
      @bp.fullname = "1234567890" * 25 
      @bp.should be_valid
    end

  end

  context "associations" do
    #it "belongs_to :bproce" do
      #should belong_to(:bproce) # процесс может иметь родительский процесс
    #end
    it "belongs_to :user" do
      should belong_to(:user) # у документа может быть ответственный
    end
    it "has_many :documents" do
      should have_many(:documents) # документы относятся к процессу
    end
    it "has_many :business_roles" do
      should have_many(:business_roles) # роли исполнителей относятся к процессу
    end
    it "has_many :bapps, :through => :bproce_bapps" do
      should have_many(:bapps).through(:bproce_bapps) # приложения относятся к процессу
    end
    it "has_many :bproce_bapps, :dependent => :destroy" do # приложения относятся к процессу
      should have_many(:bproce_bapps).dependent(:destroy) 
    end
    it "has_many :workplaces, :through => :bproce_workplaces" do
      should have_many(:workplaces).through(:bproce_workplaces) # рабочие места относятся к процессу
    end
    it "has_many :bproce_workplaces, :dependent => :destroy" do # рабочие места относятся к процессу
      should have_many(:bproce_workplaces).dependent(:destroy) 
    end
  end  


end
