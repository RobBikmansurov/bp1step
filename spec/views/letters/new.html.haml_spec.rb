
RSpec.describe "letters/new", :type => :view do
  before(:each) do
    assign(:letter, Letter.new(
      :regnumber => "MyString",
      :number => "MyString",
      :subject => "MyString",
      :source => "MyString",
      :sender => "MyText",
      :body => "MyText",
      :status => 1,
      :result => "MyText",
      :letter => nil
    ))
  end

  it "renders new letter form" do
    render

    assert_select "form[action=?][method=?]", letters_path, "post" do

      assert_select "input#letter_regnumber[name=?]", "letter[regnumber]"

      assert_select "input#letter_number[name=?]", "letter[number]"

      assert_select "input#letter_subject[name=?]", "letter[subject]"

      assert_select "input#letter_source[name=?]", "letter[source]"

      assert_select "textarea#letter_sender[name=?]", "letter[sender]"

      assert_select "textarea#letter_body[name=?]", "letter[body]"

      assert_select "input#letter_status[name=?]", "letter[status]"

      assert_select "textarea#letter_result[name=?]", "letter[result]"

      assert_select "input#letter_letter_id[name=?]", "letter[letter_id]"
    end
  end
end
