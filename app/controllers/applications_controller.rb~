class ApplicationsController < ApplicationController
  active_scaffold :application do |conf|
    config.label = "Приложения"
    conf.columns = [:app_name, :app_type, :app_note]
    conf.list.sorting = {:app_name => 'ASC'}
    conf.list.per_page = 10
  end
end 
