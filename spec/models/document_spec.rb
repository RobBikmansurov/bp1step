require 'rails_helper'

describe Document do

  context 'validations' do
    it { should validate_presence_of(:place) }
    it { should validate_presence_of(:owner_id) }
    it { should validate_length_of(:name).is_at_least(10).is_at_most(200) }
    it { should validate_numericality_of(:dlevel) }
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