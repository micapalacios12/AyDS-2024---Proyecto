# spec/spec_helper.rb

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'  # Ignorar la carpeta de pruebas
end

# Configurar el entorno de pruebas
ENV['RACK_ENV'] = 'test'

# Cargar la aplicación principal de Sinatra
require File.expand_path('../../app.rb', __FILE__)

# Requiere las bibliotecas necesarias para las pruebas
require 'rspec'
require 'rack/test'
require 'database_cleaner'

# Configurar RSpec
RSpec.configure do |config|
  # Incluye Rack::Test para poder hacer pruebas de integración de tu aplicación web
  config.include Rack::Test::Methods

  # Define el método `app` para usar la aplicación de Sinatra en las pruebas
  def app
    Sinatra::Application
  end

  # Configuración de DatabaseCleaner para limpiar la base de datos antes de las pruebas
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
