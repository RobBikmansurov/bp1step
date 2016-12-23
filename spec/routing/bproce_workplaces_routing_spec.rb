require "rails_helper"

RSpec.describe BproceWorkplacesController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(get: "/bproce_workplaces/1").to route_to("bproce_workplaces#show", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/bproce_workplaces").to route_to("bproce_workplaces#create")
    end

    it "routes to #destroy" do
      expect(delete: "/bproce_workplaces/1").to route_to("bproce_workplaces#destroy", :id => "1")
    end

  end
end
