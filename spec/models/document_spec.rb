require 'spec_helper'

PublicActivity.enabled = false

describe Document do
  before(:each) do
    @doc = create(:document)
  end

  context "validates" do
    it "is valid with valid attributes: name, delevel, bproce_id" do
      @doc.should be_valid
    end
    it "is not valid without a name" do   #validates :name, :length => {:minimum => 10, :maximum => 200}
      @doc.name = nil
      @doc.should_not be_valid
    end
    it "it require uniqueness name" do
      @docs1 = Document.new
      @docs1.name = "test_name"
      @docs1.bproce_id = 1
      @docs1.dlevel = 1
      @docs1.part = 1
      @docs1.place = 1
      @docs1.should_not be_valid
      @docs1.save
      @docs2 = Document.new
      @docs2.name = "test_name2"
      @docs2.bproce_id = 1
      @docs2.dlevel = 1
      @docs2.part = 1
      @docs2.place = 1
      @docs2.should be_valid
      @docs2.save
    end
    it "is not valid if length of name < 10 or > 200" do   #validates :name, :length => {:minimum => 10, :maximum => 200}
      @doc.name = "123456789"
      @doc.should_not be_valid
      @doc.name = "1234567890"
      @doc.should be_valid
      @doc.name = "1234567890" * 20 + "1"
      @doc.should_not be_valid
      @doc.name = "1234567890" * 20
      @doc.should be_valid
    end
    it "it not valid if dlevel < 1 or > 4" do #validates :dlevel, :numericality => {:less_than => 5, :greater_than => 0}
      @doc.dlevel = nil
      @doc.should_not be_valid
      @doc.dlevel = 0
      @doc.should_not be_valid
      @doc.dlevel = 1
      @doc.should be_valid
      @doc.dlevel = 4
      @doc.should be_valid
      @doc.dlevel = 5
      @doc.should_not be_valid
    end

    it "" do  #validates :bproce_id, :presence => true # документ относится к процессу
    end

    #it "sanityze documents file name" do
      #@doc.eplace = "/path/file.ext"
      #@doc.eplace.should == "/path/file.ext"
      #@doc.eplace = "/path/file.ext"
      #@doc.file_name.should == "/path/file.ext"
    #end
  end
 
  context "associations" do
    it "belongs_to :bproce" do
      should belong_to(:bproce) # документ принадлежит одному процессу
    end
    it "belongs_to :owner" do
      should belong_to(:owner).class_name(:User) # у документа может быть ответственный
    end
    it "has_many :directive, :through => :document_directive" do
      should have_many(:directive).through(:document_directive) # на основании директивы может быть несколько документов
    end
    it "has_many :document_directive, :dependent => :destroy" do # has_many :document_directive, :dependent => :destroy
      should have_many(:document_directive).dependent(:destroy) 
    end
  end  

end
