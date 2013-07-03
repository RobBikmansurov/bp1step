require "spec_helper"

describe BproceWorkplacesController do
  describe "routing" do

    it "routes to #show" do
      get("/bproce_workplaces/1").should route_to("bproce_workplaces#show", :id => "1")
    end

    it "routes to #create" do
      post("/bproce_workplaces").should route_to("bproce_workplaces#create")
    end

    it "routes to #destroy" do
      delete("/bproce_workplaces/1").should route_to("bproce_workplaces#destroy", :id => "1")
    end

  end
end
