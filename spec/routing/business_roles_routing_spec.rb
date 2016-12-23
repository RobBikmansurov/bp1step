require "rails_helper"

RSpec.describe BusinessRolesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/business_roles").to route_to("business_roles#index")
    end

    it "routes to #new" do
      expect(get: "/business_roles/new").to route_to("business_roles#new")
    end

    it "routes to #show" do
      expect(get: "/business_roles/1").to route_to("business_roles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/business_roles/1/edit").to route_to("business_roles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/business_roles").to route_to("business_roles#create")
    end

    it "routes to #update" do
      expect(put: "/business_roles/1").to route_to("business_roles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/business_roles/1").to route_to("business_roles#destroy", :id => "1")
    end

    it "routes to #create_user" do
      expect(:get => "/business_roles/1/create_user").to route_to("business_roles#create_user", :id => "1")
    end
     # post :update_user

  end
end
