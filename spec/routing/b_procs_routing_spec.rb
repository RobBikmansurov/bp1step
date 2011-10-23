require "spec_helper"

describe BProcsController do
  describe "routing" do

    it "routes to #index" do
      get("/b_procs").should route_to("b_procs#index")
    end

    it "routes to #new" do
      get("/b_procs/new").should route_to("b_procs#new")
    end

    it "routes to #show" do
      get("/b_procs/1").should route_to("b_procs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/b_procs/1/edit").should route_to("b_procs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/b_procs").should route_to("b_procs#create")
    end

    it "routes to #update" do
      put("/b_procs/1").should route_to("b_procs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/b_procs/1").should route_to("b_procs#destroy", :id => "1")
    end

  end
end
