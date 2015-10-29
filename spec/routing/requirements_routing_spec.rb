RSpec.describe RequirementsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/requirements").to route_to("requirements#index")
    end

    it "routes to #new" do
      expect(:get => "/requirements/new").to route_to("requirements#new")
    end

    it "routes to #show" do
      expect(:get => "/requirements/1").to route_to("requirements#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/requirements/1/edit").to route_to("requirements#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/requirements").to route_to("requirements#create")
    end

    it "routes to #update" do
      expect(:put => "/requirements/1").to route_to("requirements#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/requirements/1").to route_to("requirements#destroy", :id => "1")
    end

    it "routes to #create_task" do
      expect(:get => "/requirements/1/create_task").to route_to("requirements#create_task", :id => "1")
    end

  end
end
