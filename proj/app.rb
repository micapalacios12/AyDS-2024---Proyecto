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

  # Busca al usuario por su email
  user = User.find_by(email: email)

   # Verificar si el usuario existe y si la contraseña es correcta
  if user && user.authenticate(password)
    session[:user_id] = user.id
    redirect '/select_system'
  else
    # Muestra el mensaje de error si el email o contraseña son incorrectas
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

  # Valida que todos los campos estén llenos
  if [username, email, password, password_confirmation].any?(&:empty?)
    return erb :register, locals: { message: 'Please fill in all fields.' }
  end

   # Valida que el nombre de usuario no exista
  if User.exists?(username: username)
    return erb :register, locals: { message: 'Username already taken.' }
  end

   # Validar que el email no exista
  if User.exists?(email: email)
    return erb :register, locals: { message: 'Email already registered.' }
  end

  # Valida que las contraseñas coincidan
  if password != password_confirmation
    return erb :register, locals: { message: 'Passwords do not match.' }
  end

   # Crear un nuevo usuario
  user = User.new(username: username, email: email, password: password)

   # Guardar el usuario en la base de datos
  if user.save
    session[:user_id] = user.id
    redirect '/login'
  else
     # Muestra mensaje de error si la registración
    erb :register, locals: { message: 'Registration failed. Please try again.' }
  end
end

# Página de selección de sistema
get '/select_system' do
  # Verificar si el usuario ha iniciado sesión
  if session[:user_id]
     # Obtener información del usuario
    @user = User.find(session[:user_id])
    erb :select_system
  else
     # Redirigir al usuario a la página de inicio de sesión si no ha iniciado sesión
    redirect '/login'
  end
end

# Página de juego
get '/play' do
  @system = params[:system] # Obtiene el sistema seleccionado
  erb :"play_#{@system}" # Renderizar la vista correspondiente al sistema seleccionado
end

# Cerrar sesión
get '/logout' do
  session.clear
  redirect '/'
end
