# frozen_string_literal: true

require 'capybara/rspec'
require 'factory_bot_rails'
require 'simplecov'
SimpleCov.start 'rails'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Capybara::DSL

  config.before :all do
    FactoryBot.reload
    FactoryBot.factories.clear
    FactoryBot.find_definitions
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'spec/rspec_status.txt'
  config.order = :random
  Kernel.srand config.seed

  config.default_formatter = 'doc' if config.files_to_run.one?
end
