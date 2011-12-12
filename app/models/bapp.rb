class Bapp < ActiveRecord::Base
  has_many :bproces
  has_many :workplaces
end
