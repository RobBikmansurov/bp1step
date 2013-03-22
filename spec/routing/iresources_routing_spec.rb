require "spec_helper"

describe IresourcesController do
  describe "routing" do

    it "routes to #index" do
      get("/iresources").should route_to("iresources#index")
    end

    it "routes to #new" do
      get("/iresources/new").should route_to("iresources#new")
    end

    it "routes to #show" do
      get("/iresources/1").should route_to("iresources#show", :id => "1")
    end

    it "routes to #edit" do
      get("/iresources/1/edit").should route_to("iresources#edit", :id => "1")
    end

    it "routes to #create" do
      post("/iresources").should route_to("iresources#create")
    end

    it "routes to #update" do
      put("/iresources/1").should route_to("iresources#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/iresources/1").should route_to("iresources#destroy", :id => "1")
    end

  end
end
