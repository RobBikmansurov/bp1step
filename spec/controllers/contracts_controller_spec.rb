RSpec.describe ContractsController, type: :controller do

  let(:valid_attributes) { { number: '1', name: 'name', status: 'status', description: 'description', "owner_id" => "" , contract_type: "Договор"} }
  let(:valid_session) { {} }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    sign_in @user
  end

  describe "GET index" do
    it "assigns all contracts as @contracts" do
      contract = Contract.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:contracts)).to eq([contract])
    end
  end

  describe "GET show" do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :show, {:id => contract.to_param}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "GET new" do
    it "assigns a new contract as @contract" do
      get :new, {}, valid_session
      expect(assigns(:contract)).to be_a_new(Contract)
    end
  end

  describe "GET edit" do
    it "assigns the requested contract as @contract" do
      contract = Contract.create! valid_attributes
      get :edit, {:id => contract.to_param}, valid_session
      expect(assigns(:contract)).to eq(contract)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contract" do
        expect {
          post :create, {:contract => valid_attributes}, valid_session
        }.to change(Contract, :count).by(1)
      end

      it "assigns a newly created contract as @contract" do
        post :create, {:contract => valid_attributes}, valid_session
        expect(assigns(:contract)).to be_a(Contract)
        expect(assigns(:contract)).to be_persisted
      end

      it "redirects to the created contract" do
        post :create, {:contract => valid_attributes}, valid_session
        expect(response).to redirect_to(Contract.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contract as @contract" do
        #Contract.any_instance.stub(:save).and_return(false)
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        post :create, {:contract => { "owner_id" => "invalid value" }}, valid_session
        expect(assigns(:contract)).to be_a_new(Contract)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        post :create, {:contract => { "owner_id" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contract" do
        contract = Contract.create! valid_attributes
        #Contract.any_instance.should_receive(:update).with({ "owner_id" => "" })
        expect_any_instance_of(Contract).to receive(:save).at_least(:once)
        put :update, {:id => contract.to_param, :contract => { "owner_id" => "" }}, valid_session
      end

      it "assigns the requested contract as @contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => valid_attributes}, valid_session
        expect(assigns(:contract)).to eq(contract)
      end

      it "redirects to the contract" do
        contract = Contract.create! valid_attributes
        put :update, {:id => contract.to_param, :contract => valid_attributes}, valid_session
        expect(response).to redirect_to(contract)
      end
    end

    describe "with invalid params" do
      it "assigns the contract as @contract" do
        contract = Contract.create! valid_attributes
        #Contract.any_instance.stub(:save).and_return(false)
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        put :update, {:id => contract.to_param, :contract => { "owner_id" => "invalid value" }}, valid_session
        expect(assigns(:contract)).to eq(contract)
      end

      it "re-renders the 'edit' template" do
        contract = Contract.create! valid_attributes
        #Contract.any_instance.stub(:save).and_return(false)
        expect_any_instance_of(Contract).to receive(:save).and_return(false)
        put :update, {:id => contract.to_param, :contract => { "owner_id" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contract" do
      contract = Contract.create! valid_attributes
      expect {
        delete :destroy, {:id => contract.to_param}, valid_session
      }.to change(Contract, :count).by(-1)
    end

    it "redirects to the contracts list" do
      contract = Contract.create! valid_attributes
      delete :destroy, {:id => contract.to_param}, valid_session
      expect(response).to redirect_to(contracts_url)
    end
  end

end
