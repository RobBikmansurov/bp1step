require 'spec_helper'

describe "users/show", :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.roles << Role.find_or_create_by(name: 'admin', description: 'description')
    assign(:usr, @user)
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  it "render the users page" do
    render
    expect(rendered).to render_template(:show)
  end

  it "render active user block" do
    render
    expect(rendered).to include(@user.firstname)
    expect(rendered).to include(@user.lastname)
    expect(rendered).to include(@user.middlename.to_s + ',')
    expect(rendered).to include(@user.position.to_s)
  end

  it 'render without admin links' do
    render
    expect(rendered).not_to match(/Edit/)
    expect(rendered).not_to match(/order/)
  end


  it 'render edit link for admin' do
    @ability.can :assign_roles, User
    render
    expect(rendered).to match(/Edit/)
  end

  it 'render author link' do
    @ability.can :update, Bproce
    render
    expect(rendered).to match(/order/)
  end

end
