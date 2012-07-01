require 'spec_helper'

describe Staff do
  before(:each) do
    @st = Staff.new
    @st.fullname = "staff_fullname_1"
    @st.position = "staff_position_1"
    #@st.supervisor = false
  end
  
  it "should require fullname" do
    @st.fullname = nil
    @st.should be_valid
  end

end
