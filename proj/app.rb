# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require './models/user'
require './models/question'
require './models/option'

require_relative 'helpers/game_helpers'
require_relative 'helpers/user_helpers'
require_relative 'helpers/evaluation_helpers'

helpers GameHelpers
helpers EvaluationHelpers
helpers UserHelpers

enable :sessions # Habilita uso de sesiones
set :database_file, './config/database.yml'

# Página principal
get '/' do
  erb :home
end

# Página para usuarios regulares
get '/home_user' do
  erb :home_user
end

# Página para administradores
get '/home_admin' do
  erb :home_admin
end

# Ruta para procesar el inicio de sesión del admin
post '/admin/login' do
  email = params[:email]
  password = params[:password]

  # Busca el usuario por el email
  user = User.find_by(email: email)

  # Verifica si el usuario existe, la contraseña es correcta y es admin
  if user&.authenticate(password) && user.role == 'admin'
    session[:user_id] = user.id
    redirect '/admin/dashboard'
  else
    erb :home_admin, locals: { message: 'Email o contraseña inválidos, o no eres administrador.' }
  end
end

# Ruta para mostrar el panel de administrador después de iniciar sesión
get '/admin/dashboard' do
  redirect '/home_admin' unless session[:user_id] && User.find(session[:user_id]).role == 'admin'
  erb :admin_dashboard # Esta es la nueva vista que crearemos
end

# Ruta para cargar preguntas
get '/admin/cargar-preguntas' do
  erb :cargar_preguntas
end

# Ruta para procesar la adición de nuevas preguntas
post '/admin/add_question' do
  system = params[:system]
  level = params[:level].to_i
  text = params[:text]
  options = [
    params[:option1],
    params[:option2],
    params[:option3],
    params[:option4]
  ]
  correct_option_index = params[:correct_option].to_i - 1

  # Crear la nueva pregunta
  question = Question.create(system: system, text: text, level: level)

  # Crear las opciones de respuesta
  options.each_with_index do |option_text, index|
    Option.create(
      text: option_text,
      correct: index == correct_option_index,
      question_id: question.id
    )
  end

  redirect '/admin/cargar-preguntas'
end

# Ruta para consultas
get '/admin/consultas' do
  redirect '/home_admin' unless session[:user_id] && User.find(session[:user_id]).role == 'admin'
  erb :consultas
end

# Ruta que procesa la consulta
post '/admin/consultas/resultado' do
  cantidad = params[:cantidad].to_i
  veces = params[:veces].to_i
  tipo = params[:tipo] # 'correctas' o 'incorrectas'

  if tipo == 'correctas'
    @questions = Question.listar_correctas(cantidad, veces)
    @mostrar_correctas = true
    @mostrar_incorrectas = false
  elsif tipo == 'incorrectas'
    @questions = Question.listar_incorrectas(cantidad, veces)
    @mostrar_correctas = false
    @mostrar_incorrectas = true
  else
    @questions = [] # Maneja el caso de un tipo no válido
    @mostrar_correctas = false
    @mostrar_incorrectas = false
  end

  erb :result_consultas
end

# Página de login
get '/login' do
  erb :login
end

post '/login' do
  email = params[:email]
  password = params[:password]

  user = User.find_by(email: email) # Busca el usuario por su mail

  if user&.authenticate(password)
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
  names = params[:names]
  username = params[:username]
  email = params[:email]
  password = params[:password]
  password_confirmation = params[:password_confirmation]

  # Validar campos vacíos
  if params[:names]&.empty? || params[:username]&.empty? || params[:email]&.empty?
    return erb :register, locals: { message: 'Please fill in all fields.' }
  end

  # Validar coincidencia de contraseñas
  return erb :register, locals: { message: 'Passwords do not match.' } if password != password_confirmation

  # Crear el nuevo usuario
  user = User.new(names: names, username: username, email: email, password: password)

  if user.save
    session[:user_id] = user.id
    redirect '/login'
  else
    message = user.errors[:username].first || user.errors[:email].first || 'Registration failed.'
    erb :register, locals: { message: message }
  end
end

# Mostrar la página de perfil
get '/profile' do
  @user = current_user # usuario actual
  erb :profile
end

# Procesar la actualización del perfil
post '/update_profile' do
  user = current_user
  user.update(
    names: params[:name],
    password: params[:password],
    avatar: params[:avatar]
  )
  redirect '/profile'
end

# Pagina de configuracion
get '/configuracion' do
  @user = current_user
  erb :configuracion
end

post '/configuracion' do
  @user = current_user

  # Actualizar el avatar si se selecciona uno
  @user.avatar = params[:avatar] if params[:avatar].present?

  # Actualizar el nombre, username, email
  @user.names = params[:names] if params[:names].present?
  @user.username = params[:username] if params[:username].present?
  @user.email = params[:email] if params[:email].present?

  # Actualizar la contraseña si se proporciona una nueva
  if params[:password].present? && params[:password_confirmation] == params[:password]
    @user.password = params[:password]
  end

  # Guardar los cambios
  if @user.save
    redirect '/profile' # Redirigir de nuevo al perfil o a otra página
  else
    erb :configuracion # Volver a la vista de configuración en caso de error
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

get '/select_level/:system' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @system = params[:system]
    session[:system] = @system

    @levels = [1, 2, 3]
    @current_level = get_level(@user, @system) # Usar la función auxiliar para obtener el nivel

    erb :select_level, locals: { system: @system, levels: @levels, current_level: @current_level }
  else
    redirect '/login'
  end
end

# Ruta para mostrar la leccion del nivel seleccionado
get '/lesson/:system/:level' do
  if session[:user_id]
    @system = params[:system]
    session[:system] = @system
    @level = params[:level].to_i

    # Verificar el nivel y cargar la vista adecuada
    #
    case @level
    when 1
      erb :lesson
    when 2
      erb :lesson_level2
    when 3
      erb :lesson_level3
    else
      erb :select_system
    end
  end
end

# Ruta para iniciar el juego desde la lección
post '/level/:level/start_play' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    @system = session[:system]
    @level = params[:level].to_i
    current_level_completed = get_level(@user, @system)

    if @level <= current_level_completed
      session[:level] = @level
      session[:current_question_index] = 0
      redirect '/play/question'
    else
      @message = "Necesitas completar el nivel #{current_level_completed} antes de acceder a este nivel."
      erb :select_level, locals: { system: @system, levels: [1, 2, 3], message: @message }
    end
  else
    redirect '/login'
  end
end

# Ruta para mostrar la pregunta actual y manejar la respuesta del usuario
get '/play/question' do
  if session[:user_id]
    @level = session[:level]
    @system = session[:system]
    @current_question_index = session[:current_question_index] || 0

    @questions = get_questions_for_level(@system, @level)

    if @current_question_index < @questions.count
      @current_question = @questions[@current_question_index]
      erb :play, locals: { message: session[:last_message] } # Pasar el mensaje guardado
    else
      redirect '/select_system' # Redirigir si no hay más preguntas
    end
  else
    redirect '/login'
  end
end

post '/play/question' do
  if session[:user_id]
    handle_play_question
  else
    redirect '/login'
  end
end

# Rutas para consultas de preguntas
get '/question/incorrect/:n' do
  n = params[:n].to_i
  @questions_incorrectas = Question.listar_preguntas_incorrectas(n)
end

get '/question/correct/:n' do
  n = params[:n].to_i
  @questions_correctas = Question.listar_preguntas_correctas(n)
end

get '/finish_play' do
  @system = session[:system]
  @last_message = session[:last_message] # Recuperar el mensaje de las sesion
  erb :finish_play
end

# Ruta para preparar la evaluacion
get '/ready_for_evaluation' do
  @system = session[:system]
  @level = session[:level]
  @questions = get_questions_for_level(@system, @level)
  erb :evaluation
end

# Ruta para procesar las respuestas del usuario y mostrar el resultado de la evaluación
post '/submit_evaluation' do
  process_evaluation_submission
end

# Cerrar sesión
get '/logout' do
  session.clear
  redirect '/'
end
