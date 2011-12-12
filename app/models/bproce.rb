class Bproce < ActiveRecord::Base
  has_many :documents
  has_many :roles
  has_many :bapp
end
