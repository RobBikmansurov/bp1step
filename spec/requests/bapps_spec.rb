# encoding: utf-8
require 'spec_helper'

describe "Приложения" do
  describe "Незарегистрированный пользователь" do
    it "видит таблицу с полями Наименование и Описание" do
      @bapps = create(:bapp)
      get bapps_path
      response.status.should be(200)
      expect(response.body).to include("Наименование</a>")
      expect(response.body).to include("Описание</a>")
      expect(response.body).to include("Список")
      expect(response.body).to include("Тип")
      expect(response.body).to include("Теги")
      expect(response.body).to include("<div class='apple_pagination'>")
      #expect(response.body).to include("Каталог")
      #expect(response.body).to include("Добавить новое приложение")
    end
  end

  it "создать новое и попасть в список" do
    get "/bapps/new"
    expect(response).to render_template(:new)
    post "/bapps", :bapp => {:name => "bapp", description: 'description'}
    expect(response).to redirect_to(assigns(:bapp))
    follow_redirect!
    expect(response).to render_template(:show)
    expect(response.body).to include("Successfully created bapp.")
  end

end
