require "spec_helper"

describe BproceDocumentsController do
  describe "routing -   resources :bproce_documents, :only => [:show]" do

    it "routes to #show" do
      get("/bproce_documents/1").should route_to("bproce_documents#show", :id => "1")
    end

  end
end
