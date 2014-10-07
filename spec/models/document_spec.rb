require 'spec_helper'

describe Document do
  context 'validations' do
    it { should ensure_length_of(:name).is_at_least(10).is_at_most(200) }
    it { should validate_numericality_of(:dlevel) }
    #it { should ensure_inclusion_of(:dlevel).in_range(1..4) }
    #it { should validate_presence_of(:bproce_id) }
    it { should validate_presence_of(:place) }
    #it { should validate_presence_of(:part) }
    it { should validate_presence_of(:owner_id) }


   it "it not valid if dlevel < 1 or > 4" do #validates :dlevel, :numericality => {:less_than => 5, :greater_than => 0}
     @doc = create(:document)
     @doc.dlevel = nil
     expect(@doc).not_to be_valid
     @doc.dlevel = 0
     expect(@doc).not_to be_valid
     @doc.dlevel = 1
     expect(@doc).to be_valid
     @doc.dlevel = 4
     expect(@doc).to be_valid
     @doc.dlevel = 5
     expect(@doc).not_to be_valid
   end


  end
 
  context "associations" do
    #it { should belong_to(:bproce) }
    it { should have_many(:bproce_document).dependent(:destroy) }
    it { should belong_to(:owner).class_name(:User) }
    it { should have_many(:directive).through(:document_directive) }
    it { should have_many(:document_directive).dependent(:destroy) }
  end  

  context "have_attached_file" do
    it { should have_attached_file(:document_file) }
    it { should_not validate_attachment_presence(:document_file) }
    it { should_not validate_attachment_size(:document_file).
                less_than(2.megabytes) }
  end
  
end