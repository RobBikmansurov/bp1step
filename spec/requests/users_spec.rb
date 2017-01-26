require 'rails_helper'

PublicActivity.without_tracking do
  describe "Public access to users", type: :request do
    it "denies access to users#index" do

      get users_path
      expect(response).to render_template :index
    end
    it "denies access to users#new" do
      get "/users/1/edit"
      expect(response).to_not render_template(:new)

      get edit_user_path
      expect(response).to redirect_to new_user_session_path # sign_in
    end

    it "denies access to users#create" do
      user_attributes = FactoryGirl.attributes_for(:user)

      expect {
        post "/users", { user: user_attributes }
      }.to_not change(User, :count)

      expect(response).to
       render_template :new
    end
  end
end
