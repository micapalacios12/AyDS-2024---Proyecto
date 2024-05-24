require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

require './models/user'
require './models/question'
require './models/option'

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

# Página de selección de sistema
get '/select_system' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :select_system
  else
    redirect '/login'
  end
end

# Página de juego
get '/play' do
  if session[:user_id]
    @system = params[:system]
    session[:current_question_index] = 0
    session[:system] = @system
    redirect '/play/question'
  else
    redirect '/login'
  end
end

# Ruta para mostrar la pregunta actual
get '/play/question' do
  @system = session[:system]
  @current_question_index = session[:current_question_index]
  @questions = Question.where(system: @system)

  if @current_question_index < @questions.count
    @current_question = @questions[@current_question_index]
    erb :"play_#{@system}"
  else
    redirect '/select_system' # Redirige al usuario a seleccionar sistema al completar todas las preguntas
  end
end

# Ruta para manejar la respuesta del usuario
post '/play/answer' do
  @system = session[:system]
  @current_question_index = session[:current_question_index]
  @questions = Question.where(system: @system)
  @current_question = @questions[@current_question_index]
  
  selected_option_id = params[:option_id].to_i
  selected_option = Option.find(selected_option_id)
  
  if selected_option.correct?
    @message = "¡Respuesta correcta!"
  else
    @message = "Respuesta incorrecta. Inténtalo de nuevo."
  end

  session[:current_question_index] += 1
  erb :"play_#{@system}", locals: { message: @message }
end

# Cerrar sesión
get '/logout' do
  session.clear
  redirect '/'
end

