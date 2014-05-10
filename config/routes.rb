BPDoc::Application.routes.draw do
  resources :document_directives
  resources :directives do
    resources :documents  # документы на основании директивы
    get :autocomplete, :on => :collection
  end
  resources :bapps, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :bproces, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :iresources, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :users, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :workplaces, :only => :autocomlete do
    get :autocomplete, :on => :collection
  end
  resources :activities
  resources :bapps
  resources :bproce_workplaces, :only => [:create, :destroy, :show]
  resources :bproce_documents, :except => :index
  resources :bproce_business_roles, :only => [:show]
  resources :bproce_iresources, :only => [:new, :create, :destroy, :show, :edit, :update]
  resources :bproce_bapps, :only => [:create, :destroy, :show, :edit, :update]
  resources :bproces do
    resources :bapps, :documents
    collection do
      get :manage
      post :rebuild
      get :list
    end
    member do
      get :order  # распоряжение о назначении исполнителей в процесс
      get :doc    # описание процесса
      get :card   # карточка процесса
    end
  end
  resources :metrics
  get 'bproces/tags/:tag', to: 'bproces#index', as: :tag_bproces
  get 'bapps/tags/:tag', to: 'bapps#index', as: :tag_bapps
  get 'documents/tags/:tag', to: 'documents#index', as: :tag_documents
  #get 'tags/:tag', to: 'bproces#index', as: :tag
  #get 'tags', to: 'bproces#index'
  resources :business_roles
  resources :categories
  resources :documents do
    member do
      get :file_create
      get :file_delete
      patch :update_file
      get :approval_sheet # Лист согласования
    end
  end
  resources :iresources
  resources :roles, only: [:index, :show]
  resources :terms
  resources :user_workplaces
  resources :user_business_roles, :only => [:new, :create, :destroy, :edit, :update, :show]

  #match '/bproceses' => 'bproces#list', :via => :get  # получение полного списка процессов
  match '/bprocess' => 'bproces#manage', :via => :get  # получение полного списка процессов
  #match '/bproces/:id/card' => 'bproces#card', :via => :get  # карточка процесса
  #match '/bproces/:id/doc' => 'bproces#doc', :via => :get  # заготовка описания процесса
  match '/workplaces/switch' => 'workplaces#switch', :via => :get  # подключения рабочих мест
  resources :workplaces
  
  match '/about' => 'pages#about', :via => :get
  get 'pages/about'
  devise_for :users
  devise_scope :users do
    get "sign_in",  :to => "devise/sessions#new"
    get "sign_out", :to => "devise/sessions#destroy"
    get "sign_up",  :to => "devise/registrations#new"
  end
  resources :users, :only => [:index, :show, :edit, :update] do
    member do
      get :order  # распоряжение о назначении исполнителя на роли в процессах
    end
  end
  root :to => "home#index"

end
