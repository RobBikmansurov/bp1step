# frozen_string_literal: true

# app/models/concerns/filterable.rb
module Filterable
  extend ActiveSupport::Concern
  module ClassMethods
    def filter(filtering_params)
      results = where(nil) # Return all the records of a model.
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
