require "spec_helper"

describe AgentsController do
  describe "routing" do

    it "routes to #index" do
      get("/agents").should route_to("agents#index")
    end

    it "routes to #new" do
      get("/agents/new").should route_to("agents#new")
    end

    it "routes to #show" do
      get("/agents/1").should route_to("agents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/agents/1/edit").should route_to("agents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/agents").should route_to("agents#create")
    end

    it "routes to #update" do
      put("/agents/1").should route_to("agents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/agents/1").should route_to("agents#destroy", :id => "1")
    end

  end
end
