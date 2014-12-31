require "spec_helper"

RSpec.describe "Приложения" do

  it "creates a  bapp and redirects to the Bapp's page" do
    get "/bapp/new"
    expect(response).to render_template(:new)

    post "/bapps", :bapp => {:name => "Bapp_name"}

    expect(response).to redirect_to(assigns(:bapp))
    follow_redirect!

    expect(response).to render_template(:show)
    expect(response.body).to include("Bapp was successfully created.")
  end

end