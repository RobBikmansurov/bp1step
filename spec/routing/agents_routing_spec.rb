RSpec.describe 'AgentsController', :type => :routing do

  it "routes to #index" do
    expect(get: '/agents').to route_to("agents#index")
    expect(agents_path).to eq('/agents')
  end

  it "routes to #new" do
    expect(get: "/agents/new").to route_to("agents#new")
  end

  it "routes to #show" do
    expect(get: "/agents/1").to route_to("agents#show", :id => "1")
  end

  it "routes to #edit" do
    expect(get: "/agents/1/edit").to route_to("agents#edit", :id => "1")
  end

  it "routes to #create" do
    expect(post: "/agents").to route_to("agents#create")
  end

  it "routes to #update" do
    expect(put: "/agents/1").to route_to("agents#update", :id => "1")
  end

  it "routes to #destroy" do
    expect(delete: "/agents/1").to route_to("agents#destroy", :id => "1")
  end

end
