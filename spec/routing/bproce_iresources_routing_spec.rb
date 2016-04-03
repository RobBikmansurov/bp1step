RSpec.describe BproceIresourcesController, :type => :routing do
  describe "routing" do

    it "routes to #new" do
      expect(get: "/bproce_iresources/new").to route_to("bproce_iresources#new")
    end

    it "routes to #show" do
      expect(get: "/bproce_iresources/1").to route_to("bproce_iresources#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/bproce_iresources/1/edit").to route_to("bproce_iresources#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/bproce_iresources").to route_to("bproce_iresources#create")
    end

    it "routes to #update" do
      expect(put: "/bproce_iresources/1").to route_to("bproce_iresources#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bproce_iresources/1").to route_to("bproce_iresources#destroy", :id => "1")
    end

  end
end
