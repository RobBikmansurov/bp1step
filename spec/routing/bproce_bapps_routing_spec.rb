require "spec_helper"

describe BproceBappsController do
  describe "routing" do

    it "routes to #index" do
      get("/bproce_bapps").should route_to("bproce_bapps#index")
    end

    it "routes to #new" do
      get("/bproce_bapps/new").should route_to("bproce_bapps#new")
    end

    it "routes to #show" do
      get("/bproce_bapps/1").should route_to("bproce_bapps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bproce_bapps/1/edit").should route_to("bproce_bapps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bproce_bapps").should route_to("bproce_bapps#create")
    end

    it "routes to #update" do
      put("/bproce_bapps/1").should route_to("bproce_bapps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bproce_bapps/1").should route_to("bproce_bapps#destroy", :id => "1")
    end

  end
end
