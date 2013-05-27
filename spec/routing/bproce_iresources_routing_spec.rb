require "spec_helper"

describe BproceIresourcesController do
  describe "routing" do

    it "routes to #index" do
      get("/bproce_iresources").should route_to("bproce_iresources#index")
    end

    it "routes to #new" do
      get("/bproce_iresources/new").should route_to("bproce_iresources#new")
    end

    it "routes to #show" do
      get("/bproce_iresources/1").should route_to("bproce_iresources#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bproce_iresources/1/edit").should route_to("bproce_iresources#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bproce_iresources").should route_to("bproce_iresources#create")
    end

    it "routes to #update" do
      put("/bproce_iresources/1").should route_to("bproce_iresources#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bproce_iresources/1").should route_to("bproce_iresources#destroy", :id => "1")
    end

  end
end
