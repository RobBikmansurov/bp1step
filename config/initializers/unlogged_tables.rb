# config/initializers/unlogged_tables.rb

if Rails.env.test?  
  ActiveSupport.on_load(:active_record) do
    #ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.create_unlogged_tables = true 
  end
end
