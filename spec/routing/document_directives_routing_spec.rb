require "spec_helper"

describe DocumentDirectivesController do
  describe "routing" do

    it "routes to #index" do
      get("/document_directives").should route_to("document_directives#index")
    end

    it "routes to #new" do
      get("/document_directives/new").should route_to("document_directives#new")
    end

    it "routes to #show" do
      get("/document_directives/1").should route_to("document_directives#show", :id => "1")
    end

    it "routes to #edit" do
      get("/document_directives/1/edit").should route_to("document_directives#edit", :id => "1")
    end

    it "routes to #create" do
      post("/document_directives").should route_to("document_directives#create")
    end

    it "routes to #update" do
      put("/document_directives/1").should route_to("document_directives#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/document_directives/1").should route_to("document_directives#destroy", :id => "1")
    end

    it "routes to documents for directive" do
      get("/directives/1/documents").should route_to("documents#index", directive_id: "1" )
    end

  end
end
