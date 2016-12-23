require "rails_helper"

RSpec.describe UsersController, :type => :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/users").to route_to("users#index")
    end
    it "routes to #show" do
      expect(get: "/users/1").to route_to("users#show", :id => "1")
    end
    it "routes to #edit" do
      expect(get: "/users/1/edit").to route_to("users#edit", :id => "1")
    end
    it "routes to #update" do
      expect(put: "/users/1").to route_to("users#update", :id => "1")
    end
    it "not routes to #create" do
      expect(patch: "/users/1").to_not route_to("users#create", :id => "1")
    end

    it "routes to #order" do
      expect(get: "/users/1/order").to route_to("users#order", :id => "1")
    end

    it "routes to #autocomplete" do
      expect(get: "/users/autocomplete").to route_to("users#autocomplete")
    end

  end
end
