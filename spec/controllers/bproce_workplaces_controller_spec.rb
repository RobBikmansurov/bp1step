require 'spec_helper'

describe BproceWorkplacesController do

  def valid_attributes
    {
      id: 1,
      bproce_id: 1,
      workplace_id: 1
    }
  end
  before(:each) do
    @bproce = create(:bproce)
    @workplace = create(:workplace)
  end

  def valid_session
    {}
  end

  #  resources :bproce_workplaces, :only => [:create, :destroy, :show]

  describe "GET show" do
    it "assigns the requested bproce_workplace as @bproce_workplace" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      bproce_workplace.bproce_id = @bproce.id
      bproce_workplace.workplace_id = @workplace.id
      get :show, {:id => 1.to_param}, valid_session
      expect(assigns(:workplaces)).to eq(@bproce.workplaces)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BproceWorkplace" do
        expect {
          post :create, {:bproce_workplace => valid_attributes}, valid_session
        }.to change(BproceWorkplace, :count).by(1)
      end

      it "assigns a newly created bproce_workplace as @bproce_workplace" do
        post :create, {:bproce_workplace => valid_attributes}, valid_session
        assigns(:bproce_workplace).should be_a(BproceWorkplace)
        assigns(:bproce_workplace).should be_persisted
      end

      it "redirects to the created bproce_workplace" do
        post :create, {:bproce_workplace => valid_attributes}, valid_session
        response.should redirect_to(@workplace)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bproce_workplace as @bproce_workplace" do
        # Trigger the behavior that occurs when invalid params are submitted
        BproceWorkplace.any_instance.stub(:save).and_return(false)
        post :create, {:bproce_workplace => {bproce_id: 1, workplace_id: 1}}, valid_session
        assigns(:bproce_workplace).should be_a_new(BproceWorkplace)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested bproce_workplace" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      expect {
        delete :destroy, {:id => bproce_workplace.to_param}, valid_session
      }.to change(BproceWorkplace, :count).by(-1)
    end

    it "redirects to the bproce_workplaces list" do
      bproce_workplace = BproceWorkplace.create! valid_attributes
      delete :destroy, {:id => bproce_workplace.to_param}, valid_session
      response.should redirect_to(workplace_url(1))
    end
  end

end
