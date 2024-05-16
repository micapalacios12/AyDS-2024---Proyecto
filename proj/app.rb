# app.rb
require 'sinatra'

class App < Sinatra::Base
  get '/' do
    erb :inicio
  end

  post '/saludo' do
    nombre = params[:nombre]
    contraseña = params[:contraseña]
    "¡Hola, #{nombre}! Tu contraseña es #{contraseña}."
  end

  # Otras rutas
  get '/posts' do
    title = params['title']
    author = params['author']
    "Title: #{title}, Author: #{author}"
  end

  get '/users/:name' do |n|
    "Hello #{n}!"
  end
end

