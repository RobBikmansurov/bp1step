RSpec.describe DirectivesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/directives").to route_to("directives#index")
    end

    it "routes to #new" do
      expect(get: "/directives/new").to route_to("directives#new")
    end

    it "routes to #show" do
      expect(get: "/directives/1").to route_to("directives#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/directives/1/edit").to route_to("directives#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/directives").to route_to("directives#create")
    end

    it "routes to #update" do
      expect(put: "/directives/1").to route_to("directives#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/directives/1").to route_to("directives#destroy", :id => "1")
    end

  end
end
