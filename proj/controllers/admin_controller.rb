# frozen_string_literal: true

# Controlador de administración para gestionar las funciones y rutas específicas del administrador.
class AdminController < Sinatra::Base
  enable :sessions
  set :views, File.expand_path('../views', __dir__)

  helpers GameHelpers
  helpers EvaluationHelpers
  helpers UserHelpers

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
end
