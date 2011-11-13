require "spec_helper"

describe WorkplacesController do
  describe "routing" do

    it "routes to #index" do
      get("/workplaces").should route_to("workplaces#index")
    end

    it "routes to #new" do
      get("/workplaces/new").should route_to("workplaces#new")
    end

    it "routes to #show" do
      get("/workplaces/1").should route_to("workplaces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/workplaces/1/edit").should route_to("workplaces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/workplaces").should route_to("workplaces#create")
    end

    it "routes to #update" do
      put("/workplaces/1").should route_to("workplaces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/workplaces/1").should route_to("workplaces#destroy", :id => "1")
    end

  end
end
