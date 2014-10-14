require 'spec_helper'

describe Directive do
  before(:each) do
    @directive = create(:directive)
    #stub(current_user: FactroryGirl.create(:user))
  end

  context "validates" do
    it { should validate_presence_of(:approval) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_least(10) }
    it { should ensure_length_of(:status).is_at_most(30) }
    it { should ensure_length_of(:body).is_at_least(2).is_at_most(100) }
  end

  context "associations" do
    it { should have_many(:document).through(:document_directive) } # на основании директивы может быть несколько документов
    it { should have_many(:document_directive).dependent(:destroy) }
  end  

end
