# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

require './models/user.rb'


enable :sessions
set :database_file, './config/database.yml'

#Pagina principal

get '/' do
  erb :home
end

#Pagina de registro
get '/login' do
  erb :login
end

post '/login' do
  email = params [:email]
  password = params [:password]

  user = User.find_by(email: email)

  if user && user.authenticate(password)
    sessions[:user_id] = user.id
    redirect  '/dashboard'

  else
    erb :login, locals: {
      error: 'Invalid email or password.' }
  end
end

#ruta de registro
get '/register' do
  erb :register
end

post '/register' do
  username = params[:username]
  email = params[:email]
  password = params[:password]
  password_confirmation = params[:password_confirmation]


  if [username, email, password, password_confirmation].any?(&:empty?)
    return erb :register, locals: { message: 'Please fill in all fields.' }
  end

  if User.exists?(username: username)
    return erb :register, locals: { message: 'Username already taken.' }
  end

  if User.exists?(email: email)
    return erb :register, locals: { message: 'Email already registered.' }
  end

  if password != password_confirmation
    return erb :register, locals: { message: 'Passwords do not match.' }
  end

  user = User.new(username: username, email: email, password: password)

  if user.save
    session[:user_id] = user.id
    redirect '/dashboard'
  else
    erb :register, locals: { message: 'Registration failed. Please try again.' }
  end
end


get '/dashboard' do
  if session[:username]
    @user = User.find(session[:username])
    erb :dashboard
  else
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end
