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

  context 'POST /login with invalid credentials' do
    it 'shows an error message for invalid credentials' do
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

    it 'fails to register with mismatched passwords' do
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'wrongpassword'
      expect(last_response.body).to include('Passwords do not match.')
    end
  end

  context 'POST /register with missing fields' do
    it 'shows an error message for missing fields' do
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
    it 'redirects to login if not authenticated' do # Verifica que se redirija a la página de login si no está autenticado
      get '/lesson'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end

    it 'sets the system in the session and loads the lesson page if authenticated' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Enviar el parámetro :system con la solicitud
      get '/lesson', { system: 'math' }, 'rack.session' => { user_id: user.id }
      
      # Verifica que el sistema se haya guardado en la sesión
      expect(last_response).to be_ok
      expect(last_response.body).to include('Lesson Page Content') # Ajusta según el contenido de tu página de lección
      expect(last_request.env['rack.session']['system']).to eq('math')
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

    it 'redirects to login if not authenticated' do
      post '/start_play'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end  
  end

  context 'POST /play with selected option' do
    it 'shows correct or incorrect message and advances to the next question' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
  
      # Setup para la prueba
      question = Question.create!(text: 'What is 2+2?', system: 'math')
      correct_option = Option.create!(text: '4', correct: true, question: question)
      Option.create!(text: '5', correct: false, question: question)
  
      post '/start_play', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }
  
      # Simula la selección de la opción correcta
      post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }
      expect(last_response.body).to include('¡Respuesta correcta!')
    end
  end

  # Pruebas para la ruta de la pregunta actual
context 'GET /play/question' do
  it 'redirects to login if not authenticated' do
    get '/play/question'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/select_system')
  end

  it 'loads the question page if authenticated and questions are available' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    Question.create!(text: 'What is 2+2?', system: 'math') # Crear una pregunta para la prueba

    post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'math' }

    get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }
    expect(last_response).to be_ok
    expect(last_response.body).to include('What is 2+2?')
  end

  it 'redirects to /select_system if there are no more questions' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'math', current_question_index: 0 }

    get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 1, system: 'math' }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/select_system')
  end
end

# Pruebas para manejar respuestas en /play/question
context 'POST /play/question' do
  let!(:question) { Question.create!(text: 'What is 2+2?', system: 'math') }
  let!(:correct_option) { Option.create!(text: '4', correct: true, question: question) }
  let!(:wrong_option) { Option.create!(text: '5', correct: false, question: question) }

  it 'shows correct message for correct answer' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }

    post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }
    expect(last_response.body).to include('¡Respuesta correcta!')
  end

  it 'shows incorrect message for wrong answer' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }

    post '/play/question', option_id: wrong_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }
    expect(last_response.body).to include("Respuesta incorrecta. La correcta es: #{correct_option.text}.")
  end

  it 'advances to the next question after answering' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    post '/start_play', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }

    post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'math' }

    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/play/question')
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




end