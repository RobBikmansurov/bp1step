require "spec_helper"

describe BprocesController do
  describe "routing" do

    it "routes to #index" do
      get("/bproces").should route_to("bproces#index")
    end

    it "routes to #new" do
      get("/bproces/new").should route_to("bproces#new")
    end

    it "routes to #show" do
      get("/bproces/1").should route_to("bproces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bproces/1/edit").should route_to("bproces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bproces").should route_to("bproces#create")
    end

    it "routes to #update" do
      put("/bproces/1").should route_to("bproces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bproces/1").should route_to("bproces#destroy", :id => "1")
    end

    it "routes to #card" do
      get("/bproces/1/card").should route_to("bproces#card", :id => "1")
    end

  end
end
