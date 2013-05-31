require 'spec_helper'
describe BproceDocumentsController, "#show" do
  it { should permit(:title, :description).for(:create) }

  context "for a fictional user" do
  	before { post :create, user: { email: 'user@example.com' }, format: :html }
    before do
      get :show, :id => 1
    end

    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should_not set_the_flash }
  end

end
