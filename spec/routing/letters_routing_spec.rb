RSpec.describe LettersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/letters").to route_to("letters#index")
    end

    it "routes to #new" do
      expect(:get => "/letters/new").to route_to("letters#new")
    end

    it "routes to #show" do
      expect(:get => "/letters/1").to route_to("letters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/letters/1/edit").to route_to("letters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/letters").to route_to("letters#create")
    end

    it "routes to #update" do
      expect(:put => "/letters/1").to route_to("letters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/letters/1").to route_to("letters#destroy", :id => "1")
    end

    it "routes to #senders" do
      expect(:get => "/letters/senders").to route_to("letters#senders")
    end
    it "routes to #log_week" do
      expect(:get => "/letters/log_week").to route_to("letters#log_week")
    end
    it "routes to #check" do
      expect(:get => "/letters/check").to route_to("letters#check")
    end
    it "routes to #register" do
      expect(:get => "/letters/1/register").to route_to("letters#register", :id => "1")
    end
    it "routes to #appendix_create" do
      expect(:get => "/letters/1/appendix_create").to route_to("letters#appendix_create", :id => "1")
    end
    it "routes to #appendix_delete" do
      expect(:get => "/letters/1/appendix_delete").to route_to("letters#appendix_delete", :id => "1")
    end
    #  post :appendix_update
    it "routes to #clone" do
      expect(:get => "/letters/1/clone").to route_to("letters#clone", :id => "1")
    end
    it "routes to #create_outgoing" do
      expect(:get => "/letters/1/create_outgoing").to route_to("letters#create_outgoing", :id => "1")
    end
    it "routes to #create_requirement" do
      expect(:get => "/letters/1/create_requirement").to route_to("letters#create_requirement", :id => "1")
    end
    it "routes to #create_user" do
      expect(:get => "/letters/1/create_user").to route_to("letters#create_user", :id => "1")
    end
     # post :update_user
    it "routes to #register" do
      expect(:get => "/letters/1/register").to route_to("letters#register", :id => "1")
    end
    it "routes to #create_task" do
      expect(:get => "/letters/1/create_task").to route_to("letters#create_task", :id => "1")
    end

  end
end
