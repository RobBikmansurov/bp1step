RSpec.describe BprocesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/bproces").to route_to("bproces#index")
    end

    it "routes to #new" do
      expect(get: "/bproces/new").to route_to("bproces#new")
    end

    it "routes to #show" do
      expect(get: "/bproces/1").to route_to("bproces#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/bproces/1/edit").to route_to("bproces#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/bproces").to route_to("bproces#create")
    end

    it "routes to #update" do
      expect(put: "/bproces/1").to route_to("bproces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/bproces/1").to route_to("bproces#destroy", :id => "1")
    end

    it "routes to #card" do
      expect(get: "/bproces/1/card").to route_to("bproces#card", :id => "1")
    end
    it "routes to #order" do
      expect(get: "/bproces/1/order").to route_to("bproces#order", :id => "1")
    end
    it "routes to #autocomplete" do
      expect(get: "/bproces/autocomplete").to route_to("bproces#autocomplete")
    end


  end
end
