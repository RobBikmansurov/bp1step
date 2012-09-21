require "spec_helper"

describe DirectivesController do
  describe "routing" do

    it "routes to #index" do
      get("/directives").should route_to("directives#index")
    end

    it "routes to #new" do
      get("/directives/new").should route_to("directives#new")
    end

    it "routes to #show" do
      get("/directives/1").should route_to("directives#show", :id => "1")
    end

    it "routes to #edit" do
      get("/directives/1/edit").should route_to("directives#edit", :id => "1")
    end

    it "routes to #create" do
      post("/directives").should route_to("directives#create")
    end

    it "routes to #update" do
      put("/directives/1").should route_to("directives#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/directives/1").should route_to("directives#destroy", :id => "1")
    end

  end
end
