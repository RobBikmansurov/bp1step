require "rails_helper"

RSpec.describe BproceBappsController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/bproce_bapps/1").to route_to("bproce_bapps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/bproce_bapps/1/edit").to route_to("bproce_bapps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/bproce_bapps").to route_to("bproce_bapps#create")
    end

    it "routes to #update" do
      expect(put: "/bproce_bapps/1").to route_to("bproce_bapps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bproce_bapps/1").to route_to("bproce_bapps#destroy", :id => "1")
    end

  end
end
