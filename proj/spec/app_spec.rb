# spec/app_spec.rb
require 'spec_helper'

#Describe block para agrupar las pruebas de las rutas de la aplicación
RSpec.describe 'App Routes', type: :request do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  #Pruebas para home 
  context 'GET /' do
    it 'returns a successful response' do # Verifica que la respuesta sea exitosa
      get '/'
      expect(last_response).to be_ok
    end

    it 'renders the home page content' do # Verifica que el contenido de la página de inicio esté presente
      get '/'
      expect(last_response.body).to include("Bienvenido a \"AnatomyEasy\"")
    end
  end

  #Pruebas para la ruta de login (GET)
  context 'GET /login' do
    it 'returns a successful response' do # Verifica que la respuesta sea exitosa
      get '/login'
      expect(last_response).to be_ok
    end
  
    it 'renders the login page content' do # Verifica que el contenido de la página de login esté presente
      get '/login'
      expect(last_response.body).to include("Iniciar Sesión")
    end
  end
  
  #Prueba para el POST de login
  context 'POST /login' do
    let!(:user) do
      User.create!(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123' # Esto se almacenará como texto plano en el modelo (y luego será cifrado por el modelo User si es necesario)
      )
    end

    it 'logs in successfully with valid credentials' do # Verifica que el inicio de sesión sea exitoso
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/select_system')
    end
  end

  context 'POST /login with invalid credentials' do #Iniciar sesión con credenciales no válidas
    it 'shows an error message for invalid credentials' do #muestra un mensaje de error para credenciales no válidas
      post '/login', username: 'wronguser', email: 'wrong@example.com', password: 'wrongpassword'
      expect(last_response.body).to include('Invalid email or password.')
    end
  end
  

  #Prueba para la ruta de registro (GET)
  context 'GET /register' do
    it 'returns a successful response' do # Verifica que la respuesta sea exitosa
      get '/register'
      expect(last_response).to be_ok
    end

    it 'renders the register page content' do # Verifica que el contenido de la página de registro esté presente
      get '/register'
      expect(last_response.body).to include("Register")
    end
  end

  #Prueba para el POST de registro con datos válidos
  context 'POST /register' do
    it 'registers a new user and redirects to login' do # Verifica que se registre un nuevo usuario y se redirija a la página de login
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'password123'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it 'fails to register with mismatched passwords' do #No se puede registrar con contraseñas no coincidentes
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'wrongpassword'
      expect(last_response.body).to include('Passwords do not match.')
    end
  end

  context 'POST /register with missing fields' do # registrarse con campos faltantes
    it 'shows an error message for missing fields' do #muestra un mensaje de error por campos faltantes
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com'
      expect(last_response.body).to include('Registration failed. Please try again.')
    end
  end
  

  #Prueba para la selección del sistema (GET)
  context 'GET /select_system' do
    it 'redirects to login if not authenticated' do # Verifica que se redirija a la página de login si no está autenticado
      get '/select_system'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it 'loads the select system page if authenticated' do # Verifica que se cargue la página de selección del sistema si está autenticado
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'

      expect(last_response).to be_redirect
      follow_redirect!

      get '/select_system', {}, 'rack.session' => { user_id: user.id }

      expect(last_response).to be_ok
      expect(last_response.body).to include("Seleccionar Sistema")
    end
  end

  #Pruebas adicionales para las rutas de lección, juego y evaluación
  context 'GET /lesson' do
    it 'sets the system in the session and loads the lesson page if authenticated' do # Establece el sistema en la sesión y carga la página de la lección si está autenticado
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Enviar el parámetro :system con la solicitud
      get '/lesson', { system: 'digestivo' }, 'rack.session' => { user_id: user.id }
      
      # Verifica que el sistema se haya guardado en la sesión
      expect(last_response).to be_ok
      expect(last_response.body).to include('Estoy listo para responder las preguntas') # Ajusta según el contenido de tu página de lección
    end
  end
  
  context 'POST /start_play' do
    it 'starts the game if authenticated' do # Verifica que se inicie el juego si está autenticado
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'

      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'math' }
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/play/question')
    end

    it 'redirects to login if not authenticated' do #Redirige al inicio de sesión si no está autenticado
      post '/start_play'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end  
  end

  context 'POST /play with selected option' do
    it 'shows correct or incorrect message and advances to the next question' do # Muestra el mensaje correcto o incorrecto y avanza a la siguiente pregunta.
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
  
      # Setup para la prueba
      question = Question.create!(text: '¿Cúal es la función principal del sistema digestivo?', system: 'digestivo')
      correct_option = Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question)
      Option.create!(text: 'Producir hormonas', correct: false, question: question)
  
      post '/start_play', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }
  
      # Simula la selección de la opción correcta
      post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }
    end
  end

  # Pruebas para la ruta de la pregunta actual
  context 'GET /play/question' do
    it 'loads the question page if authenticated and questions are available' do #Carga la página de preguntas si está autenticado y hay preguntas disponibles.
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      Question.create!(text: '¿Cúal es la función principal del sistema digestivo?', system: 'digestivo') # Crear una pregunta para la prueba1
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo' }

      get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }
      expect(last_response).to be_ok
      expect(last_response.body).to include('¿Cúal es la función principal del sistema digestivo?')
    end

    it 'redirects to /select_system if there are no more questions' do #Redirecciona a /select_system si no hay más preguntas
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo', current_question_index: 0 }

      get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 1, system: 'digestivo' }
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/select_system')
    end
  end

# Pruebas para manejar respuestas en /play/question
context 'POST /play/question' do
  it 'advances to the next question after answering' do #avanza a la siguiente pregunta después de responder
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    post '/login', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo' }

    #post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 1, system: 'digestivo' }
    #expect(last_response.body).to include('¡Respuesta correcta!')
    #expect(session[:current_question_index]).to eq(1)
  end
end

  context 'GET /game_over' do
    it 'shows the game over page with the last message' do # Verifica que se muestre la página de fin del juego con el último mensaje
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      get '/game_over', {}, 'racksession' => { user_id: user.id, last_message: "shows the game over page with the last message" }
      expect(last_response).to be_ok
      expect(last_response.body).to include("¡Has terminado el juego!")
    end
  end

  #Prueba para logout
  context 'GET /logout' do
    it 'clears the session and redirects to the home page' do # borra la sesión y redirecciona a la página de inicio
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      
      # Iniciar sesión para establecer la sesión del usuario
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
  
      # Verificar que la sesión está establecida
      expect(last_request.env['rack.session']['user_id']).to eq(user.id)
      
      # Solicitar la ruta de cierre de sesión
      get '/logout', {}, 'rack.session' => { user_id: user.id }
      
      # Verificar que la sesión ha sido borrada
      expect(last_request.env['rack.session']['user_id']).to be_nil
      
      # Verificar que el usuario es redirigido a la página principal
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

end