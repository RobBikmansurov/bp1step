# frozen_string_literal: true

RSpec.describe RolesController, type: :controller do
  def valid_attributes
    {
      id: 1,
      name: 'test_role',
      description: 'test_role_description'
    }
  end

  def valid_session
    {}
  end

  describe 'GET index' do
    it 'assigns all roles as @roles' do
      Role.all.each(&:destroy)
      role = Role.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:roles)).to eq([role])
    end
  end

  describe 'GET show' do
    it 'assigns the requested role as @role' do
      role = Role.create! valid_attributes
      get :show, { id: role.to_param }, valid_session
      expect(assigns(:role)).to eq(role)
    end
  end
end
