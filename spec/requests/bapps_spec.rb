# encoding: utf-8
require 'spec_helper'

describe 'Приложение', :type => :feature do
  def set_fields(title, body, another)
    visit '/bapps'

    click_link 'Создать запрос'    

    within("#form") do
      fill_in 'model_title', :with => title
      fill_in 'model_body', :with => body
      fill_in 'model_another_field', :with => another
    end
    
    click_button 'Создать'
  end
end

describe "Приложения" do
  describe "Незарегистрированный пользователь" do
    it "видит таблицу с полями Наименование и Описание" do
      @bapps = create(:bapp)
      get bapps_path
      response.status.should be(200)
      expect(response.body).to include("Наименование</a>")
      expect(response.body).to include("Описание</a>")
      expect(response.body).to include("Тип")
      expect(response.body).to include("Теги")
      expect(response.body).to include("<div class='apple_pagination'>")
      #expect(response.body).to include("Каталог")
      #expect(response.body).to include("Добавить новое приложение")
    end
  end

  it "создать новое и попасть в список" do
    puts new_bapp_pathe.status.should be(20
    get new_bapp_path
    response.status.should be(200)
    #expect(response).to render_template(:new)
    post "/bapps", :bapp => {:name => "bapp", description: 'description'}
    expect(response).to redirect_to(assigns(:bapp))
    follow_redirect!
    expect(response).to render_template(:show)
    expect(response.body).to include("Successfully created bapp.")
  end

end
