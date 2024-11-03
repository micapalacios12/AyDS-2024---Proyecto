# spec/app_spec.rb
require 'spec_helper'

#Describe block para agrupar las pruebas de las rutas de la aplicación
RSpec.describe 'App Routes', type: :request do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:admin_user) { User.create(username: 'admin', email: 'admin@example.com', password: 'password', role: 'admin') }
  let(:regular_user) { User.create(username: 'user',email: 'user@example.com', password: 'password', role: 'user') }
  
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

  # Pruebas para la página de inicio de usuario regular
  context 'GET /home_user' do
    it 'renders the home_user page for authenticated users' do
      get '/home_user'
      
      # Verifica que la respuesta sea exitosa 
      expect(last_response).to be_ok
      # Verifica que se esté renderizando la vista correcta
      expect(last_response.body).to include('home_user') # Asegúrate de que un contenido específico esté en la vista
    end
  end

  # Pruebas para la página de inicio del administrador
  context 'GET /home_admin' do
    it 'renders the home_admin page for authenticated admin users' do
      get '/home_admin'
      
      # Verifica que la respuesta sea exitosa (código 200)
      expect(last_response).to be_ok
      # Verifica que se esté renderizando la vista correcta
      expect(last_response.body).to include('home_admin') # Asegúrate de que hay un contenido específico en la vista
    end
  end

  # Prueba para procesar el inicio de sesión del admin
  context 'POST /admin/login' do
    it 'logs in the admin with valid credentials and redirects to dashboard' do
      post '/admin/login', email: admin_user.email, password: 'password'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/dashboard')
      expect(last_request.env['rack.session'][:user_id]).to eq(admin_user.id)
    end

    it 'renders home_admin with an error message for invalid credentials' do
      post '/admin/login', email: admin_user.email, password: 'wrong_password'
      expect(last_response.body).to include('Email o contraseña inválidos, o no eres administrador.')
      expect(last_request.env['rack.session'][:user_id]).to be_nil
    end

    it 'renders home_admin with an error message if user is not admin' do
      post '/admin/login', email: regular_user.email, password: 'password'
      expect(last_response.body).to include('Email o contraseña inválidos, o no eres administrador.')
      expect(last_request.env['rack.session'][:user_id]).to be_nil
    end
  end

  # Prueba para el panel de administrador
  context 'GET /admin/dashboard' do
    it 'allows access to the admin dashboard for admin users' do
      # Simula que el usuario está autenticado como admin
      post '/admin/login', email: admin_user.email, password: 'password'
      get '/admin/dashboard'
      expect(last_response).to be_ok
      expect(last_response.body).to include('admin_dashboard') # Asegúrate de que hay contenido específico en la vista
    end

    it 'redirects non-admin users to home_admin' do
      post '/admin/login', email: regular_user.email, password: 'password'
      get '/admin/dashboard'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/home_admin')
    end

    it 'redirects unauthenticated users to home_admin' do
      get '/admin/dashboard'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/home_admin')
    end
  end

  # Prueba para cargar preguntas
  context 'GET /admin/cargar-preguntas' do
    it 'renders the cargar_preguntas page for authenticated admin users' do
      post '/admin/login', email: admin_user.email, password: 'password'
      get '/admin/cargar-preguntas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('cargar_preguntas') # Asegúrate de que hay contenido específico en la vista
    end

    it 'redirects unauthenticated users to login page' do
      get '/admin/cargar-preguntas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/home_admin')
    end
  end

  # Prueba para procesar la adición de nuevas preguntas
  context 'POST /admin/add_question' do
    it 'adds a question and redirects to cargar-preguntas' do
      post '/admin/login', email: admin_user.email, password: 'password'
      post '/admin/add_question', {
        system: 'digestivo',
        level: 1,
        text: '¿Cuál es la función del sistema digestivo?',
        option1: 'Opción 1',
        option2: 'Opción 2',
        option3: 'Opción 3',
        option4: 'Opción 4',
        correct_option: '1'
      }
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/admin/cargar-preguntas')
    end
  end

  # Prueba para las consultas
  context 'GET /admin/consultas' do
    it 'renders the consultas page for authenticated admin users' do
      post '/admin/login', email: admin_user.email, password: 'password'
      get '/admin/consultas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('consultas') # Asegúrate de que hay contenido específico en la vista
    end

    it 'redirects unauthenticated users to home_admin' do
      get '/admin/consultas'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/home_admin')
    end
  end

  # Prueba para procesar la consulta
  context 'POST /admin/consultas/resultado' do
    before do
      allow(Question).to receive(:listar_correctas).and_return([])
      allow(Question).to receive(:listar_incorrectas).and_return([])
    end

    it 'lists correct questions when tipo is correctas' do
      post '/admin/login', email: admin_user.email, password: 'password'
      post '/admin/consultas/resultado', cantidad: 5, veces: 2, tipo: 'correctas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas') # Asegúrate de que hay contenido específico en la vista
    end

    it 'lists incorrect questions when tipo is incorrectas' do
      post '/admin/login', email: admin_user.email, password: 'password'
      post '/admin/consultas/resultado', cantidad: 5, veces: 2, tipo: 'incorrectas'
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas')
    end

    it 'handles invalid tipo gracefully' do
      post '/admin/login', email: admin_user.email, password: 'password'
      post '/admin/consultas/resultado', cantidad: 5, veces: 2, tipo: 'otro_tipo'
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas')
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
    it 'registers a new user and redirects to login' do
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'password123'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  
    it 'fails to register with mismatched passwords' do
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'wrongpassword'
      expect(last_response.body).to include('Passwords do not match.')
    end
  
    it 'fails to register when the username is already taken' do
      # Crea un usuario con el mismo nombre de usuario para simular la situación
      User.create(names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123')
      
      post '/register', names: 'Jane Doe', username: 'johndoe', email: 'jane@example.com', password: 'password123', password_confirmation: 'password123'
      expect(last_response.body).to include('Username already taken.')
    end
  
    it 'fails to register when the email is already registered' do
      # Crea un usuario con el mismo email para simular la situación
      User.create(names: 'John Doe', username: 'johnny', email: 'john@example.com', password: 'password123')
      
      post '/register', names: 'Jane Doe', username: 'janedoe', email: 'john@example.com', password: 'password123', password_confirmation: 'password123'
      expect(last_response.body).to include('Email already registered.')
    end
  
    it 'shows an error message for missing fields' do
      post '/register', names: 'John Doe', username: '', email: '', password: '', password_confirmation: ''
      expect(last_response.body).to include('Please fill in all fields.')
    end

    it 'shows an error message if user registration fails' do
      # Simula que `user.save` falla
      allow_any_instance_of(User).to receive(:save).and_return(false)
      
      post '/register', names: 'John Doe', username: 'johndoe', email: 'john@example.com', password: 'password123', password_confirmation: 'password123'
      
      expect(last_response.body).to include('Registration failed.')
    end
  end

  # Verificar la página de perfil
  context 'GET /profile' do
    it 'renders the profile page for the current user' do
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      get '/profile'
      expect(last_response).to be_ok
      expect(last_response.body).to include('profile') # Asegúrate de que hay contenido específico en la vista
    end

    it 'redirects unauthenticated users to login page' do
      get '/profile'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login') # Cambia esto a la ruta correcta de tu login
    end
  end

  # Procesar la actualización del perfil
  context 'POST /update_profile' do
    it 'updates the user profile and redirects to profile page' do
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      post '/update_profile', name: 'Updated Name', password: 'newpassword', avatar: 'new_avatar.png'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/profile')

      # Verifica que los datos se hayan actualizado
      updated_user = User.find(regular_user.id)
      expect(updated_user.names).to eq('Updated Name')
      expect(updated_user.password).not_to eq('password') # La contraseña debería haber cambiado
      expect(updated_user.avatar).to eq('new_avatar.png')
    end

    it 'redirects to the profile page even if no changes are made' do
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      post '/update_profile', name: '', password: '', avatar: ''
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/profile')
    end
  end

  # Página de configuración
  context 'GET /configuracion' do
    it 'renders the settings page for the current user' do
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      get '/configuracion'
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Asegúrate de que hay contenido específico en la vista
    end

    it 'redirects unauthenticated users to login page' do
      get '/configuracion'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login') # Cambia esto a la ruta correcta de tu login
    end
  end

  # Procesar la configuración
  context 'POST /configuracion' do
    it 'updates user settings and redirects to profile' do
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      post '/configuracion', names: 'New Name', username: 'newusername', email: 'new@example.com', avatar: 'new_avatar.png', password: 'newpassword', password_confirmation: 'newpassword'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/profile')

      # Verifica que los datos se hayan actualizado
      updated_user = User.find(regular_user.id)
      expect(updated_user.names).to eq('New Name')
      expect(updated_user.username).to eq('newusername')
      expect(updated_user.email).to eq('new@example.com')
      expect(updated_user.avatar).to eq('new_avatar.png')
      expect(updated_user.password).not_to eq('password') # La contraseña debería haber cambiado
    end

    it 'renders the settings page if there is an error updating the user' do
      allow_any_instance_of(User).to receive(:save).and_return(false) # Simula un error al guardar
      post '/login', email: regular_user.email, password: 'password' # Simula el inicio de sesión
      post '/configuracion', names: 'New Name', username: 'newusername', email: 'new@example.com'
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Asegúrate de que hay contenido específico en la vista
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

  describe 'GET /select_level/:system' do
    context 'cuando el usuario está autenticado' do
      it 'muestra la página de selección de nivel' do
        post '/login', email: regular_user.email, password: 'password'
        get '/select_level/digestivo'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Seleccionar nivel') # Asegúrate de que el texto esté presente
      end
  
      it 'redirige al login si el usuario no está autenticado' do
        get '/select_level/digestivo'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  describe 'GET /lesson/:system/:level' do
    context 'cuando el usuario está autenticado' do
      it 'muestra la lección del nivel 1' do
        post '/login', email: regular_user.email, password: 'password'
        get '/lesson/digestivo/1'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Lección 1') # Asegúrate de que el texto esté presente
      end
  
      it 'muestra la lección del nivel 2' do
        post '/login', email: regular_user.email, password: 'password'
        get '/lesson/digestivo/2'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Lección 2') # Asegúrate de que el texto esté presente
      end
  
      it 'muestra la lección del nivel 3' do
        post '/login', email: regular_user.email, password: 'password'
        get '/lesson/digestivo/3'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Lección 3') # Asegúrate de que el texto esté presente
      end
  
      it 'redirige a select_system si el nivel no es válido' do
        post '/login', email: regular_user.email, password: 'password'
        get '/lesson/digestivo/99' # Nivel no válido
        expect(last_response).to be_ok
        expect(last_response.body).to include('Seleccionar sistema') # Asegúrate de que redirija
      end
    end
  end 

  #Prueba para inicial el juego desde la leccion
  context 'POST /level/:level/start_play' do
    let!(:user) do
      User.create!(
        names: 'Test User',
        username: 'testuser',
        email: 'user@example.com',
        password: 'password'
      )
    end

    before do
      # Simular el nivel completado del usuario
      allow(user).to receive(:level_completed).and_return(1)
    end


    context 'cuando el usuario está autenticado' do
      it 'permite al usuario iniciar el juego para un nivel completado' do
        post '/login', email: 'user@example.com', password: 'password'

        post '/level/1/start_play' # El nivel completado

        expect(last_response).to be_redirect
        follow_redirect! # Sigue la redirección a la página de juego
        expect(last_request.path).to eq('/play/question') # Asegúrate de que se redirige correctamente
      end

      it 'previene que el usuario inicie un nivel más alto' do
        post '/login', email: 'user@example.com', password: 'password'

        post '/level/2/start_play' # El nivel no completado

        expect(last_response).to be_ok
        expect(last_response.body).to include('Necesitas completar el nivel 1 antes de acceder a este nivel.') # Verifica el mensaje
      end
    end

    context 'cuando el usuario no está autenticado' do
      it 'redirige a los usuarios no autenticados a la página de inicio de sesión' do
        session.clear # Limpiar la sesión para simular un usuario no autenticado

        post '/level/1/start_play'

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  # Pruebas para la ruta que muestra la pregunta actual
  context 'GET /play/question' do
    let!(:user) do
      User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    end
    
    before do
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      session[:level] = 1
      session[:system] = 'digestivo'
      session[:current_question_index] = 0

    end

    context 'when user is authenticated' do
      before do
        # Crea preguntas para el nivel y sistema especificados
        Question.create!(text: '¿Cúal es la función principal del sistema digestivo?', system: 'digestivo', level: 1)
        Question.create!(text: '¿Qué órganos componen el sistema digestivo?', system: 'digestivo', level: 1)
      end

      before do
        # Crear preguntas para el nivel y sistema especificados
        Question.create!(text: '¿Cúal es la función principal del sistema digestivo?', system: 'digestivo', level: 1)
      end

      it 'loads the question page if questions are available' do
        session[:current_question_index] = 0 # Asegúrate de que el índice de la pregunta esté en el rango correcto

        get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: session[:current_question_index], system: session[:system] }

        expect(last_response).to be_ok
        expect(last_response.body).to include('¿Cúal es la función principal del sistema digestivo?')
      end

      it 'redirects to /select_system if there are no more questions' do
        session[:current_question_index] = 2 # Simula que no hay más preguntas disponibles

        get '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: session[:current_question_index], system: session[:system] }

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/select_system')
      end
    end

    context 'when user is not authenticated' do
      before do
        session.clear # Limpia la sesión para simular un usuario no autenticado
      end

      it 'redirects to /login' do
        get '/play/question'

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end

  # Pruebas para la ruta POST /play/question
  context 'POST /play/question' do
    let!(:user) do
      User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    end

    let!(:question) do
      Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo', level: 1)
    end

    let!(:correct_option) do
      Option.create!(text: 'Absorción de nutrientes', question: question, correct: true)
    end

    let!(:incorrect_option) do
      Option.create!(text: 'Digestión de alimentos', question: question, correct: false)
    end

    before do
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
    end

    it 'correctly processes a valid correct answer' do
      post '/play/question', { option_id: correct_option.id }, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo', level: 1 }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/play/question')
      expect(last_response.body).to include('¡Respuesta correcta!')
      expect(last_request.session[:current_question_index]).to eq(1) # Verificamos el índice de la pregunta
    end

    it 'correctly processes a valid incorrect answer' do
      post '/play/question', { option_id: incorrect_option.id }, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo', level: 1 }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_response.body).to include('Respuesta incorrecta. Vuelve a intentarlo.')
      expect(last_request.session[:current_question_index]).to eq(1) # Verificamos el índice de la pregunta
    end

    it 'shows an error message if no option is selected' do
      post '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo', level: 1 }

      expect(last_response).to be_ok
      expect(last_response.body).to include('Por favor, selecciona una opción antes de responder.')
    end

    it 'shows an error message for an invalid option' do
      post '/play/question', { option_id: 999 }, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo', level: 1 }

      expect(last_response).to be_ok
      expect(last_response.body).to include('Opción no válida.')
    end

    it 'redirects to /finish_play if there are no more questions' do
      post '/play/question', { option_id: correct_option.id }, 'rack.session' => { user_id: user.id, current_question_index: 1, system: 'digestivo', level: 1 }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/finish_play') # Debe redirigir al final del juego
    end
  end

  context 'GET /question/incorrect/:n' do
    it 'displays n incorrect questions' do
      Question.create(text: 'Pregunta incorrecta', incorrect_count: 5, system: 'digestivo', level: 2)
      get '/question/incorrect/1'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Pregunta incorrecta')
    end
  end

  context 'GET /question/correct/:n' do
    it 'displays n correct questions' do
      Question.create(text: 'Pregunta correcta', correc_count: 5, system: 'digestivo', level: 2)
      get '/question/correct/1'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Pregunta correcta')
    end
  end

  describe 'GET /ready_for_evaluation' do
    context 'cuando el usuario está autenticado' do
      before do
        post '/login', email: regular_user.email, password: 'password'
        session[:system] = 'digestivo'
        session[:level] = 1
      end
  
      it 'muestra la página de evaluación' do
        get '/ready_for_evaluation'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Evaluación') # Cambia a lo que sea específico en tu vista
      end
    end
  
    context 'cuando el usuario no está autenticado' do
      it 'redirige al login' do
        get '/ready_for_evaluation'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  end
  
  describe 'POST /submit_evaluation' do
    context 'cuando el usuario está autenticado' do
      before do
        post '/login', email: regular_user.email, password: 'password'
        session[:system] = 'digestivo'
        session[:level] = 1
        # Simula preguntas para evaluar
        allow_any_instance_of(Question).to receive(:count).and_return(2)
        allow(Option).to receive(:find).and_return(double(correct?: true))
      end
  
      it 'calcula el puntaje correctamente' do
        post '/submit_evaluation', 'question1' => 1, 'question2' => 2
        expect(last_response).to be_ok
        expect(last_response.body).to include('Resultado de la evaluación') # Asegúrate de que el texto esté presente
      end
  
      it 'muestra un mensaje de error si faltan respuestas' do
        post '/submit_evaluation'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Por favor, selecciona una opción para cada pregunta.')
      end
    end
  
    context 'cuando el usuario no está autenticado' do
      it 'redirige al login' do
        post '/submit_evaluation'
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
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