# spec/app_spec.rb
require 'spec_helper'

RSpec.describe 'App Routes', type: :request do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'GET /' do
    it 'returns a successful response' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'renders the home page content' do
      get '/'
      expect(last_response.body).to include("Bienvenido a \"AnatomyEasy\"")
    end
  end

  context 'GET /login' do
    it 'returns a successful response' do
      get '/login'
      expect(last_response).to be_ok
    end
  
    it 'renders the login page content' do
      get '/login'
      expect(last_response.body).to include("Iniciar Sesión")
    end
  end
  
end 