# spec/spec_helper.rb
ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__
require 'rspec'
require 'rack/test'
require 'active_record'
require 'database_cleaner'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Configuración para limpiar la base de datos entre pruebas
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.order = :random
  Kernel.srand config.seed
end
