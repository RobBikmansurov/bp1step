BPDoc::Application.routes.draw do
  resources :bproces, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :iresources, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :users, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :activities
  resources :agents do
    get :autocomplete, :on => :collection
    member do
      get :new_contract # новый договор контрагента
    end
  end
  resources :bapps do
    get :autocomplete, :on => :collection
  end
  resources :bproce_bapps, :only => [:create, :destroy, :show, :edit, :update]
  resources :bproce_business_roles, :only => [:show]
  resources :bproce_iresources, :only => [:new, :create, :destroy, :show, :edit, :update]
  resources :bproce_workplaces, :only => [:create, :destroy, :show]
  resources :bproce_documents, :except => :index
  resources :bproces do
    resources :bapps
    #resources :documents
    resources :business_roles, :only => [:new]
    resources :documents, :only => [:new, :index]
    collection do
      get :manage
      post :rebuild
      get :list
    end
    member do
      get :order  # распоряжение о назначении исполнителей в процесс
      get :doc    # описание процесса
      get :card   # карточка процесса
      get :check_list   # чек-лист карточки процесса
      get :metrics  # метрики процесса
      get :new_metric  # добавить новую метрику в процесс
      get :new_document, to: 'documents#new'
    end
  end
  resources :bproce_contracts, :except => :index
  resources :business_roles
  resources :contracts do
    get :autocomplete, :on => :collection
    member do
      get :approval_sheet # Лист согласования
      get :scan_create
      get :scan_delete
      post :update_scan
      get :bproce_create
      get :clone  # создать похожий договор
    end
  end
  resources :contract_scans, :only => [:destroy, :edit, :update]
  resources :directives do
    resources :documents  # документы на основании директивы
    get :autocomplete, :on => :collection
    member do
      get :document_create
      post :document_update
    end
  end
  resources :documents do
    get :autocomplete, :on => :collection
    member do
      get :file_create
      get :file_delete
      patch :update_file
      get :approval_sheet # Лист согласования
      get :clone  # создать карточку похожего документа
      get :add_favorite     # добровольное занесение в избранное
      get :add_to_favorite  # юрист заносит в обязательные
      post :update_favorite
    end
  end
  resources :document_directives
  resources :iresources

  resources :home, :only => [:index] do
    member do
      get :create_letter    # создать официальное письмо
      get :create_memo      # создать служебную записку
      get :create_vacation  # создать заявление на отпуск
    end
  end

  resources :metrics do
    member do
      get :values
      get :new_value
    end
  end
  resources :metric_values, :only => [:edit, :update, :new, :create, :destroy]
  get 'bproces/tags/:tag', to: 'bproces#index', as: :tag_bproces
  get 'bapps/tags/:tag', to: 'bapps#index', as: :tag_bapps
  get 'documents/tags/:tag', to: 'documents#index', as: :tag_documents
  #get 'tags/:tag', to: 'bproces#index', as: :tag
  #get 'tags', to: 'bproces#index'
  resources :roles, only: [:index, :show]
  resources :terms
  devise_for :users
  devise_scope :users do
    get "sign_in",  :to => "devise/sessions#new"
    get "sign_out", :to => "devise/sessions#destroy"
    get "sign_up",  :to => "devise/registrations#new"
  end
  resources :users, :only => [:index, :show, :edit, :update] do
    member do
      get :order  # распоряжение о назначении исполнителя на роли в процессах
      get :uworkplaces
      get :uroles
      get :documents
      get :contracts
      get :contracts_pay
      get :resources
      get :processes
    end
  end
  resources :user_business_roles, :only => [:new, :create, :destroy, :edit, :update, :show]
  resources :user_documents, only: [:destroy]
  resources :user_workplaces

  #match '/bproceses' => 'bproces#list', :via => :get  # получение полного списка процессов
  match '/bprocess' => 'bproces#manage', :via => :get  # получение полного списка процессов
  #match '/bproces/:id/card' => 'bproces#card', :via => :get  # карточка процесса
  #match '/bproces/:id/doc' => 'bproces#doc', :via => :get  # заготовка описания процесса
  match '/workplaces/switch' => 'workplaces#switch', :via => :get  # подключения рабочих мест
  resources :workplaces do
    get :autocomplete, :on => :collection
  end
  
  match '/about' => 'pages#about', :via => :get
  get 'pages/about'
  root :to => "home#index"

end