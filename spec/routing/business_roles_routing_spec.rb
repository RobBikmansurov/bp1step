require "spec_helper"

describe BusinessRolesController do
  describe "routing" do

    it "routes to #index" do
      get("/business_roles").should route_to("business_roles#index")
    end

    it "routes to #new" do
      get("/business_roles/new").should route_to("business_roles#new")
    end

    it "routes to #show" do
      get("/business_roles/1").should route_to("business_roles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/business_roles/1/edit").should route_to("business_roles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/business_roles").should route_to("business_roles#create")
    end

    it "routes to #update" do
      put("/business_roles/1").should route_to("business_roles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/business_roles/1").should route_to("business_roles#destroy", :id => "1")
    end

  end
end
