require "spec_helper"

describe RolesController do
  describe "routing" do

    it "routes to #index" do
      get("/roles").should route_to("roles#index")
    end

    it "routes to #show" do
      get("/roles/1").should route_to("roles#show", :id => "1")
    end

  end
end
