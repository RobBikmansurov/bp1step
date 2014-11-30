RSpec.describe DocumentsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/documents").to route_to("documents#index")
    end

    it "routes to #new" do
      expect(get: "/documents/new").to route_to("documents#new")
    end

    it "routes to #show" do
      expect(get: "/documents/1").to route_to("documents#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get: "/documents/1/edit").to route_to("documents#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post: "/documents").to route_to("documents#create")
    end

    it "routes to #update" do
      expect(put: "/documents/1").to route_to("documents#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete: "/documents/1").to route_to("documents#destroy", :id => "1")
    end

    it "routes to #file_create" do
      expect(get: "documents/1/file_create").to route_to("documents#file_create", id: '1')
    end
    it "routes to #file_delete" do
      expect(get: "documents/1/file_delete").to route_to("documents#file_delete", id: '1')
    end
    it "routes to #update_file" do
      expect(patch: "documents/1/update_file").to route_to("documents#update_file", id: '1')
    end

    it "routes to bproces documents" do
      expect(get: "/bproces/1/documents").to route_to("documents#index", bproce_id: '1')
    end
    it "routes to #clone document" do
      expect(get: "/documents/1/clone").to route_to("documents#clone", id: '1')
    end


  end
end
