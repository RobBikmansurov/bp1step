require "spec_helper"

describe BappsController do
  describe "routing" do

    it "routes to #index" do
      get("/bapps").should route_to("bapps#index")
    end

    it "routes to #new" do
      get("/bapps/new").should route_to("bapps#new")
    end

    it "routes to #show" do
      get("/bapps/1").should route_to("bapps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bapps/1/edit").should route_to("bapps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bapps").should route_to("bapps#create")
    end

    it "routes to #update" do
      put("/bapps/1").should route_to("bapps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bapps/1").should route_to("bapps#destroy", :id => "1")
    end

    describe "routing to bapps" do
      it "routes /bapps to bapps#index" do
        expect(:get => "/bapps").to route_to(
        :controller => "bapps",
        :action => "index"
        )
      end

      it "does not expose a list of profiles" do
        expect(:get => "/bapps").to be_routable
      end
    end

  end
end
