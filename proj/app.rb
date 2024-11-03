require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

#Carga de modelos necesarios
require './models/user'
require './models/question'
require './models/option'


enable :sessions #Habilita uso de sesiones 
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
  if user && user.authenticate(password) && user.role == 'admin'
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

  user = User.find_by(email: email) #Busca el usuario por su mail

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
  if password != password_confirmation
    return erb :register, locals: { message: 'Passwords do not match.' }
  end

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
  @user = current_user #usuario actual
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

#Pagina de configuracion
get '/configuracion' do
  @user = current_user 
  erb :configuracion
end

post '/configuracion' do
  @user = current_user

  # Actualizar el avatar si se selecciona uno
  if params[:avatar].present?
    @user.avatar = params[:avatar]
  end

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
    redirect '/profile'  # Redirigir de nuevo al perfil o a otra página
  else
    erb :configuracion  # Volver a la vista de configuración en caso de error
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

    #Verificar el nivel y cargar la vista adecuada
    #
    if @level == 1
      erb :lesson
    elsif @level == 2
      erb :lesson_level2
    elsif @level == 3
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

    puts "User Level Completed: #{@user.level_completed}"

    current_level_completed = get_level(@user, @system)
    puts "Nivel solicitado: #{@level}"
    puts "Nivel completado actual: #{current_level_completed}"


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
  @level = session[:level]
  @system = session[:system]
  @current_question_index = session[:current_question_index]

  @questions = get_questions_for_level(@system, @level)
  
  if @current_question_index < @questions.count
    @current_question = @questions[@current_question_index]

    # Verificar si se ha seleccionado una opción
    if params[:option_id].nil? || params[:option_id].empty?
      @message = "Por favor, selecciona una opción antes de responder."
      erb :play, locals: { message: @message }
    else
      selected_option_id = params[:option_id].to_i
      selected_option = Option.find_by(id: selected_option_id)
       
      if selected_option
        #@correct_option = @current_question.options.find_by(correct: true)

        if selected_option.correct?
        #Verificar si la opcion seleccionada es la correcta
          @message = "¡Respuesta correcta!"
          session[:current_question_index] += 1 # Avanzar al siguiente índice
          
          #Actualiza el contador de respuestas correctas en la pregunta
          @current_question.increment(:correc_count)
        else
          @message = "Respuesta incorrecta. Vuelve a intentarlo."
          #Actualiza el contador de respuestas correctas en la pregunta
          @current_question.increment(:incorrect_count)
        end

        #Guarda los cambios en la pregunta
        @current_question.save

        session[:last_message] = @message # Guardar el mensaje en la sesión

        if session[:current_question_index] < @questions.count
          redirect '/play/question' # Redirigir para mostrar la siguiente pregunta
        else
          redirect '/finish_play' # Redirigir al final del juego
        end
      else
        @message = "Opción no válida."
        erb :play, locals: { message: @message }
      end
    end
  else
    redirect '/finish_play' # Redirigir si no hay más preguntas
  end
end

#Rutas para consultas de preguntas
get '/question/incorrect/:n' do
  n = params[:n].to_i
  @questions_incorrectas = Question.listar_preguntas_incorrectas(n)
  erb :questions_incorrectas
end

get '/question/correct/:n' do
  n = params[:n].to_i
  @questions_correctas = Question.listar_preguntas_correctas(n)
  erb :questions_correctas
end



get '/finish_play' do
  @system = session[:system]
  @last_message = session[:last_message] #Recuperar el mensaje de las sesion
  erb :finish_play
end

#Ruta para preparar la evaluacion
get '/ready_for_evaluation' do
  @system = session[:system]
  @level = session[:level]
  @questions = get_questions_for_level(@system, @level)
  erb :evaluation

end

# Ruta para procesar las respuestas del usuario y mostrar el resultado de la evaluación
post '/submit_evaluation' do
  if session[:user_id]
    @score = 0
    @user = User.find(session[:user_id])
    @system = session[:system]

    # Obtener el nivel actual completado por el usuario en este sistema
    current_level = get_level(@user, @system)

    # Obtener las preguntas para el nivel actual
    @questions = get_questions_for_level(@system, session[:level])
    total_questions = @questions.count

    # Verifica si se ha seleccionado una opción para cada pregunta
    @unanswered_questions = @questions.select do |question|
      params["question#{question.id}"].nil? || params["question#{question.id}"].empty?
    end

    if @unanswered_questions.any?
      @message = "Por favor, selecciona una opción para cada pregunta."
      erb :evaluation, locals: { message: @message, questions: @questions }
    else
      # Calcular el puntaje
      @questions.each do |question|
        selected_option_id = params["question#{question.id}"].to_i
        selected_option = Option.find(selected_option_id)

        # Incrementar el puntaje si la respuesta seleccionada es correcta
        @score += 1 if selected_option && selected_option.correct?
      end

      # Si el usuario ha respondido correctamente todas las preguntas, desbloquear el siguiente nivel
      if @score == total_questions
        if session[:level].to_i == current_level
          next_level = [current_level + 1, 3].min # Asegurarse de que no exceda el nivel máximo
          update_level(@user, @system, next_level)
        end
      end

      # Mostrar la vista de resultado de la evaluación
      erb :evaluation_result, locals: { score: @score, questions: @questions }
    end
  else
    redirect '/login'
  end
end


# Cerrar sesión
get '/logout' do
  session.clear
  redirect '/'
end

helpers do

  #Método para obtener el usuario actual
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  
  def get_questions_for_level(system, level)
    Question.where(system: system, level: level)
  end


  # Obtiene el nivel actual del usuario para un sistema específico
  def get_level(user, system)
    systems_list = ['digestivo', 'respiratorio', 'circulatorio', 'reproductor']
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)
    
    if current_system_index && current_system_index < user_levels.size
      puts "Nivel completado: #{user_levels[current_system_index]}"
      user_levels[current_system_index]
    else
      1 # Nivel predeterminado
    end
  end

  # Actualiza el nivel completado del usuario para un sistema específico
  def update_level(user, system, new_level)
    systems_list = ['digestivo', 'respiratorio', 'circulatorio', 'reproductor']
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)
    
    if current_system_index
      user_levels[current_system_index] = [new_level, 3].min # Limitar el nivel máximo a 3
      user.update(level_completed: user_levels.join(','))
    end
  end
end
