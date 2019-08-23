# frozen_string_literal: true

Rails.application.routes.draw do
  resources :bproces, only: :autocomlete do
    get :autocomplete, on: :collection
  end
  resources :iresources, only: :autocomlete do
    get :autocomplete, on: :collection
  end
  resources :users, only: :autocomlete do
    get :autocomplete, on: :collection
  end
  resources :activities
  resources :agents do
    get :autocomplete, on: :collection
    member do
      get :new_contract # новый договор контрагента
    end
  end
  resources :bapps do
    get :autocomplete, on: :collection
  end
  resources :bproce_bapps, only: %i[create destroy show edit update]
  resources :bproce_business_roles, only: [:show]
  resources :bproce_iresources, only: %i[new create destroy show edit update]
  resources :bproce_workplaces, only: %i[create destroy show]
  resources :bproce_contracts, except: %i[index new]
  resources :bproce_documents, except: :index
  resources :bproces, except: :new do
    resources :bapps
    resources :business_roles, only: [:new]
    resources :documents, only: %i[new index]
    resources :contracts, only: [:index]
    collection do
      get :manage
      post :rebuild
      get :list
    end
    member do
      get :order  # распоряжение о назначении исполнителей в процесс
      get :doc    # описание процесса
      get :card   # карточка процесса
      get :check_list # чек-лист карточки процесса
      get :check_list_improve # чеклист улучшения процесса
      get :metrics # метрики процесса
      get :new_metric # добавить новую метрику в процесс
      get :new_document, to: 'documents#new'
      get :new_sub_process # добавить подпроцесс
    end
  end
  resources :business_roles do
    member do
      get :create_user # назначить исполнителя
      post :update_user
      get :mail # отправить всем исполнителям письмо
      post :mail_all
    end
  end
  resources :contracts do
    get :autocomplete, on: :collection
    member do
      get :approval_sheet # Лист согласования
      get :scan_create
      get :scan_delete
      post :update_scan
      get :bproce_create
      get :clone # создать похожий договор
    end
  end
  resources :contract_scans, only: %i[destroy edit update]
  resources :directives do
    resources :documents  # документы на основании директивы
    get :autocomplete, on: :collection
    member do
      get :document_create
      post :document_update
    end
  end
  resources :documents do
    get :autocomplete, on: :collection
    member do
      get :file_create
      get :file_delete
      patch :update_file
      get :pdf_create
      patch :update_pdf
      get :approval_sheet # Лист согласования
      get :clone # создать карточку похожего документа
      get :add_favorite     # добровольное занесение в избранное
      get :add_to_favorite  # юрист заносит в обязательные
      post :update_favorite
      get :show_files
      get :bproce_create
    end
  end
  resources :document_directives
  resources :iresources

  resources :home, only: [:index] do
    member do
      get :create_letter    # создать официальное письмо
      get :create_memo      # создать служебную записку
      get :create_vacation  # создать заявление на отпуск
    end
  end

  resources :letters do     # письма, корреспонденция
    collection do
      get :senders
      get :log_week    # журнал регистрации за неделю
      get :check       # контроль
    end
    member do
      get :appendix_create
      get :appendix_delete
      post :appendix_update
      get :clone            # письмо от того же корреспондента
      get :create_outgoing  # исходящее письмо на входящее
      get :create_requirement # создать требование
      get :create_task
      get :create_user # назначить исполнителя
      post :update_user
      get :register       # зарегистрировать
      get :reestr         # реестр выписок
    end
  end
  resources :letter_appendixes, only: %i[destroy edit update]

  resources :metrics do
    member do
      get :values
      get :new_value
      get :set
      get :test
      get :save_value
      get :set_values
    end
  end
  resources :metric_values, only: %i[edit update new create destroy]
  get 'bproces/tags/:tag', to: 'bproces#index', as: :tag_bproces
  get 'bapps/tags/:tag', to: 'bapps#index', as: :tag_bapps
  get 'documents/tags/:tag', to: 'documents#index', as: :tag_documents
  # get 'tags/:tag', to: 'bproces#index', as: :tag
  # get 'tags', to: 'bproces#index'

  resources :tasks do
    collection do
      get :check # контроль
    end
    member do
      get :create_user      # назначить исполнителя
      post :update_user
      get :report
    end
  end
  resources :terms
  resources :requirements do
    member do
      get :create_task
      get :create_user      # назначить исполнителя
      post :update_user
      get :tasks_list
      get :tasks_report
    end
  end
  resources :roles, only: %i[index show]

  devise_for :users
  devise_scope :users do
    get 'sign_in',  to: 'devise/sessions#new'
    get 'sign_out', to: 'devise/sessions#destroy'
    get 'sign_up',  to: 'devise/registrations#new'
  end
  resources :users, only: %i[index show edit update] do
    member do
      get :order # распоряжение о назначении исполнителя на роли в процессах
      get :pass # пропуск
      get :uworkplaces
      get :uroles
      get :documents
      get :contracts
      get :contracts_pay
      get :resources
      get :processes
      get :execute # К исполнению (письма, задачи, требования).
      get :avatar_create
      get :avatar_delete
      patch :update_avatar
      get :move_to # назначить другого пользователя всех бизнес-ролей сотрудника
      post :business_roles_move_to # перенести бизнес-роли новому пользователю
      get :stop_all # прератить исполнение всех ролей сотрудником
      post :documents_move_to # перенести документы другому пользователю
      get :move_documents_to
    end
    resources :roles, only: %i[create destroy]
  end
  resources :user_business_roles, only: %i[new create destroy edit update show]
  resources :user_documents, only: [:destroy]
  resources :user_letters, only: %i[destroy update create show]
  resources :user_requirements, only: %i[destroy update create show]
  resources :user_tasks, only: %i[destroy update create show]
  resources :user_workplaces

  # match '/bproceses' => 'bproces#list', :via => :get  # получение полного списка процессов
  match '/bprocess' => 'bproces#manage', :via => :get # получение полного списка процессов
  # match '/bproces/:id/card' => 'bproces#card', :via => :get  # карточка процесса
  # match '/bproces/:id/doc' => 'bproces#doc', :via => :get  # заготовка описания процесса
  match '/workplaces/switch' => 'workplaces#switch', :via => :get # подключения рабочих мест
  resources :workplaces do
    get :autocomplete, on: :collection
    member do
      get :create_user # назначить исполнителя
      post :update_user
    end
  end

  match '/about' => 'pages#about', via: :get
  root to: 'home#index'
  match '*path', to: 'pages#about', via: :all
end
