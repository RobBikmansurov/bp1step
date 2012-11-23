require 'spec_helper'
describe Bproce do
  #pending "add some examples to (or delete) #{__FILE__}"
  before(:each) do
    @bp = Bproce.new
    @bp.name = "test_process_1"
  end
  
  it "should require name" do
    @bp.name = nil
    @bp.should_not be_valid
    #@bp.errors.on(:name).should_not be_nil
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
