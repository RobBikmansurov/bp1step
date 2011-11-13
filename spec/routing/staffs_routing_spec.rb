require "spec_helper"

describe StaffsController do
  describe "routing" do

    it "routes to #index" do
      get("/staffs").should route_to("staffs#index")
    end

    it "routes to #new" do
      get("/staffs/new").should route_to("staffs#new")
    end

    it "routes to #show" do
      get("/staffs/1").should route_to("staffs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staffs/1/edit").should route_to("staffs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staffs").should route_to("staffs#create")
    end

    it "routes to #update" do
      put("/staffs/1").should route_to("staffs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staffs/1").should route_to("staffs#destroy", :id => "1")
    end

  end
end
