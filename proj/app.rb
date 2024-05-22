require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

require './models/user'

enable :sessions
set :database_file, './config/database.yml'

# Página principal
get '/' do
  erb :home
end

# Página de login
get '/login' do
  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  user = User.find_by(email: email)

  if user && user.authenticate(password)
    session[:user_id] = user.id
    redirect '/select_system'
  else
    erb :login, locals: { message: 'Invalid email or password.' }
  end
end

# Página de registro
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
    redirect '/login'
  else
    erb :register, locals: { message: 'Registration failed. Please try again.' }
  end
end

get '/select_system' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :select_system
  else
    redirect '/login'
  end
end

get '/play' do
  @system = params[:system] # Obtener el sistema seleccionado de los parámetros de la URL
  erb :"play_#{@system}" # Renderizar la vista correspondiente al sistema seleccionado
end


get '/logout' do
  session.clear
  redirect '/home'
end
