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
  names = params[:names]
  username = params[:username]
  email = params[:email]
  password = params[:password]
  password_confirmation = params[:password_confirmation]

  if params[:names]&.empty? || params[:username]&.empty? || params[:email]&.empty? #modificacion
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

  user = User.new(names: names, username: username, email: email, password: password)

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

# MOstrar los niveles para el sistema seleccionado
get '/select_level/:system' do
  if session[:user_id]
    @system = params[:system]
    @levels = [1, 2, 3] # Definir los tres niveles
    erb :select_level, locals: {system: session[:system] }
  else
    redirect '/login'
  end
end

#get '/lesson' do
 # if session[:user_id]
  #  @system = params[:system]
   # session[:system] = @system  # Guardar el sistema en la sesión
    #erb :lesson
  #else
   # redirect '/login'
  #end
#end

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
    @level = params[:level].to_i
    session[:level] = @level
    session[:current_question_index] = 0  # Inicializar el índice de la pregunta actual
    redirect '/play/question'
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
    @questions = Question.where(system: @system, level: @level)
    
      if @current_question_index < @questions.count
          @current_question = @questions[@current_question_index]
          erb :play
      else
        redirect '/select_system'
      end
  end
end 

post '/play/question' do
  @level = session[:level]
  @system = session[:system]
  @current_question_index = session[:current_question_index]
  
  @questions = Question.where(system: @system, level: @level)
  
  @current_question = @questions[@current_question_index]

  

  # Verificar si se ha seleccionado una opción
  if params[:option_id].nil? || params[:option_id].empty?
    @message = "Por favor, selecciona una opción antes de responder."
    erb :play, locals: { message: @message }
  else
    selected_option_id = params[:option_id].to_i
    selected_option = Option.find_by(id: selected_option_id)

    if selected_option
      @correct_option = @current_question.options.find_by(correct: true)

      if selected_option.correct?
        @message = "¡Respuesta correcta!"
        session[:current_question_index] += 1 # Solo avanza si la respuesta es correcta
      else
        @message = "Respuesta incorrecta. Vuelve a intentarlo."
      end

      session[:last_message] = @message #Guardar el mensaje de la sesión

      if session[:current_question_index] < @questions.count
        @current_question = @questions[session[:current_question_index]]
        erb :play, locals: { message: @message }
      else
        redirect '/finish_play'
      end
    end  
  end
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
  @questions = Question.where(system: @system, level: @level)
  erb :evaluation

end

# Ruta para procesar las respuestas del usuario y mostrar el resultado de la evaluación
post '/submit_evaluation' do
  @score = 0
  @system = session[:system]
  @level = session[:level]
  @questions = Question.where(system: session[:system], level: session[:level])


  # Verifica si se ha seleccionado una opción para cada pregunta
  @unanswered_questions = @questions.select do |question|
    params["question#{question.id}"].nil? || params["question#{question.id}"].empty?
  end

  if @unanswered_questions.any?
    @message = "Por favor, selecciona una opción para cada pregunta."
    erb :evaluation, locals: { message: @message, questions: @questions }
  else
    @questions.each do |question|
      selected_option_id = params["question#{question.id}"].to_i
      selected_option = Option.find(selected_option_id)
      @score += 1 if selected_option.correct?
    end

    erb :evaluation_result, locals: { score: @score }
  end
end

# Cerrar sesión
get '/logout' do
  session.clear
  redirect '/'
end
