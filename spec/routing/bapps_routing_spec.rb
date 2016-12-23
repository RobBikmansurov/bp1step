require "rails_helper"

RSpec.describe BappsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/bapps").to route_to("bapps#index")
    end

    it "routes to #new" do
      expect(get: "/bapps/new").to route_to("bapps#new")
    end

    it "routes to #show" do
      expect(get: "/bapps/1").to route_to("bapps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/bapps/1/edit").to route_to("bapps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/bapps").to route_to("bapps#create")
    end

    it "routes to #update" do
      expect(put: "/bapps/1").to route_to("bapps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bapps/1").to route_to("bapps#destroy", :id => "1")
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
