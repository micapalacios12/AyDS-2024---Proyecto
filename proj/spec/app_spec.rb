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

  #Pruebas para home user
  context 'GET /home_user' do
    it 'returns a successful response' do
      get '/home_user'
      expect(last_response).to be_ok
    end

    it 'renders the home_user template' do
      get '/home_user'
      expect(last_response.body).to include('<h1>Bienvenido a "AnatomyEasy"</h1>') # Ajusta el contenido según tu plantilla
    end
  end
  
  #Prueba para procesar el inicio de sesion del admin
  context 'POST /admin/login' do
    before(:each) do
      # Crea un usuario administrador antes de cada prueba
      @admin_user = User.create(email: 'admin@example.com', password: 'password', role: 'admin')
      # Crea un usuario normal para las pruebas que lo requieran
      @user = User.create(email: 'user@example.com', password: 'password', role: 'user')
    end

    it 'logs in the admin with valid credentials and redirects to dashboard' do
      post '/admin/login', email: @user.email, password: "password"
      #Verifica que la respuesta redirige al dashboard
      expect(last_response).to be_redirect
      follow_redirect!
      #Verifica que el usuario es redirigido
      expect(last_request.path).to eq('/admin/dashboard')

      # Verifica que session[:user_id] se estableció correctamente
      expect(last_request.env['rack.session'][:user_id]).to eq(@admin_user.id) # Verifica que la sesión se haya establecido
    end
    
    it 'renders home_admin with an error message for invalid credentials' do
      post '/admin/login', email: @user.email, password: "wrong_password"
      expect(last_response.body).to include('Email o contraseña inválidos, o no eres administrador.')
      expect(last_request.env['rack.session'][:user_id]).to be_nil # Verifica que no hay usuario en sesión    end
    
    it 'renders home_admin with an error message if user is not admin' do
      # Crea un usuario no admin directamente
      non_admin_user = User.create(email: "user@example.com", password: "password", password_confirmation: "password", role: "user")
      post '/admin/login', email: non_admin_user.email, password: "password"
      
      expect(last_response.body).to include('Email o contraseña inválidos, o no eres administrador.')
      expect(last_request.env['rack.session'][:user_id]).to be_nil # Verifica que la sesión no tenga user_id
      non_admin_user.destroy # Limpia después de la prueba
    end
  end

  #Pruebas para admin/dashboard
  context 'GET /admin/dashboard' do
    it 'allows access to the admin dashboard for admin users' do
      # Simula una sesión de usuario admin
      post '/admin/login', email: @admin_user.email, password: "password"
      session[:user_id] = @admin_user.id

      get '/admin/dashboard'
      
      expect(last_response).to be_ok
      expect(last_response.body).to include("Bienvenido, Administrador") # Asegúrate de que 'admin_dashboard' está en la vista
    end
  
    it 'redirects non-admin users to home_admin' do
      # Simula una sesión de usuario regular
      post '/admin/login', email: @regular_user.email, password: "password"
      session[:user_id] = @regular_user.id

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
  
  #Pruebas para admin consultas de preguntas
  context 'GET /admin/consultas' do
    it 'allows access to consultas for admin users' do
      # Simula una sesión de usuario admin
      post '/admin/login', email: @admin_user.email, password: "password"
      
      get '/admin/consultas'
      
      expect(last_response).to be_ok
      expect(last_response.body).to include("Consultas de Preguntas") # Cambia a algún texto de la vista `consultas`
    end
  end

  #Pruebas para admin/cargar preguntas
  context 'GET /admin/cargar-preguntas' do
    it 'renders the cargar_preguntas view for authenticated admin users' do
      admin_user = User.create(email: "admin@example.com", password: "password", password_confirmation: "password", role: "admin")
      post '/admin/login', email: admin_user.email, password: "password"
  
      get '/admin/cargar-preguntas'
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('cargar_preguntas') # Asegúrate de que 'cargar_preguntas' está en la vista
    end
  end
  
  #Prueba para procesar adiccion de nuevas pregiuntas
  context 'POST /admin/add_question' do
    it 'creates a new question and redirects' do
      post '/admin/add_question', system: "test_system", level: 1, text: "What is the capital of France?", 
          option1: "Berlin", option2: "Madrid", option3: "Paris", option4: "Rome", 
          correct_option: 3 # La respuesta correcta es 'Paris'
  
      expect(last_response).to be_redirect
      follow_redirect!
  
      # Verifica que redirige a la ruta esperada
      expect(last_request.path).to eq('/admin/cargar-preguntas')
  
      # Verifica que la pregunta se haya creado en la base de datos
      question = Question.last
      expect(question.text).to eq("What is the capital of France?")
      expect(question.level).to eq(1)
      expect(question.system).to eq("test_system")
      expect(Option.where(question_id: question.id).count).to eq(4) # Verifica que se hayan creado 4 opciones
    end
  end

  #Prueba que procesa la consulta
  context 'POST /admin/consultas/resultado' do
    it 'returns correct questions when tipo is "correctas"' do
      post '/admin/consultas/resultado', cantidad: 1, veces: 1, tipo: 'correctas'
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas') # Asegúrate de que 'result_consultas' está en la vista
      expect(last_request.env['rack.session'][:mostrar_correctas]).to be true
      expect(last_request.env['rack.session'][:mostrar_incorrectas]).to be false
      expect(assigns(:questions)).to include(@correct_question)
    end
  
    it 'returns incorrect questions when tipo is "incorrectas"' do
      post '/admin/consultas/resultado', cantidad: 1, veces: 1, tipo: 'incorrectas'
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas') # Asegúrate de que 'result_consultas' está en la vista
      expect(last_request.env['rack.session'][:mostrar_correctas]).to be false
      expect(last_request.env['rack.session'][:mostrar_incorrectas]).to be true
      expect(assigns(:questions)).to include(@incorrect_question)
    end
  
    it 'handles invalid tipo by returning an empty array of questions' do
      post '/admin/consultas/resultado', cantidad: 1, veces: 1, tipo: 'invalid_type'
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('result_consultas') # Asegúrate de que 'result_consultas' está en la vista
      expect(assigns(:questions)).to be_empty
      expect(last_request.env['rack.session'][:mostrar_correctas]).to be false
      expect(last_request.env['rack.session'][:mostrar_incorrectas]).to be false
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

  #Pruebas para perfil y configuracion
  context 'GET /profile and POST /update_profile' do
    it 'shows the profile page' do
      get '/profile'
      expect(last_response).to be_ok
      expect(last_response.body).to include('profile') # Asegúrate de que 'profile' está en la vista
      expect(assigns(:user)).to eq(@user)
    end
  
    it 'updates the user profile' do
      post '/update_profile', name: "Updated User", password: "newpassword", avatar: "new_avatar.png"
  
      @user.reload # Recargar el usuario para obtener los datos actualizados
  
      expect(last_response).to be_redirect
      follow_redirect! # Seguir la redirección a la página de perfil
      expect(last_response.body).to include('Updated User')
      expect(@user.authenticate("newpassword")).to be_truthy
      expect(@user.avatar).to eq("new_avatar.png")
    end
  end
  
  #Pruebas para configuracion
  describe 'GET /configuration and POST /configuration' do
    it 'shows the configuration page' do
      get '/configuracion'
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Asegúrate de que 'configuracion' está en la vista
      expect(assigns(:user)).to eq(@user)
    end
  
    it 'updates the user configuration' do
      post '/configuracion', names: "Updated User", username: "updateduser", email: "updated@example.com", password: "newpassword", password_confirmation: "newpassword"
  
      @user.reload # Recargar el usuario para obtener los datos actualizados
  
      expect(last_response).to be_redirect
      follow_redirect! # Seguir la redirección a la página de perfil
      expect(last_response.body).to include('Updated User')
      expect(@user.username).to eq("updateduser")
      expect(@user.email).to eq("updated@example.com")
      expect(@user.authenticate("newpassword")).to be_truthy
    end
  
    it 'renders the configuration page with errors if save fails' do
      allow_any_instance_of(User).to receive(:save).and_return(false) # Simula un fallo al guardar
  
      post '/configuracion', names: "Error User"
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Verifica que se volvió a la vista de configuración
    end
  end
  
  #Pruebas para configuracion
  context 'Profile Update and Configuration' do
  context 'POST /update_profile' do
    it 'updates the user profile with new information' do
      post '/update_profile', name: "Updated User", password: "newpassword", avatar: "new_avatar.png"
  
      @user.reload # Recarga el usuario para obtener los datos actualizados        expect(last_response).to be_redirect
      follow_redirect! # Sigue la redirección a la página de perfil
  
      expect(last_response.body).to include('Updated User')
      expect(@user.names).to eq("Updated User")
      expect(@user.authenticate("newpassword")).to be_truthy
      expect(@user.avatar).to eq("new_avatar.png")
    end
  end
  
  context 'GET /configuracion' do
    it 'renders the configuration page' do
      get '/configuracion'
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Asegúrate de que 'configuracion' está en la vista
      expect(assigns(:user)).to eq(@user)
    end
  end
  
  context 'POST /configuracion' do
    it 'updates user information in configuration' do
      post '/configuracion', names: "Updated Config Name", username: "updateduser", email: "updated@example.com", password: "newpassword", password_confirmation: "newpassword", avatar: "config_avatar.png"
  
      @user.reload # Recarga el usuario para obtener los datos actualizados
      expect(last_response).to be_redirect
      follow_redirect! # Sigue la redirección a la página de perfil
  
      expect(last_response.body).to include('Updated Config Name')
      expect(@user.names).to eq("Updated Config Name")
      expect(@user.username).to eq("updateduser")
      expect(@user.email).to eq("updated@example.com")
      expect(@user.authenticate("newpassword")).to be_truthy
      expect(@user.avatar).to eq("config_avatar.png")
    end
  
    it 'does not update password if confirmation does not match' do
      post '/configuracion', password: "newpassword", password_confirmation: "mismatch"
  
      @user.reload # Recarga el usuario para obtener los datos actualizados
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Asegúrate de que permanece en la página de configuración
      expect(@user.authenticate("newpassword")).to be_falsey # La contraseña no debe actualizarse
    end
  
    it 'renders the configuration page with errors if save fails' do
      allow_any_instance_of(User).to receive(:save).and_return(false) # Simula un fallo al guardar
      post '/configuracion', names: "Error Config Name"
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('configuracion') # Verifica que vuelve a la vista de configuración
      expect(@user.names).not_to eq("Error Config Name") # El nombre no debe haberse actualizado
    end
  end

  #Prueba para la selección del sistema (GET)
  context 'GET /select_system' do
  
    it 'renders the select_system page for authenticated users' do
      # Simula el inicio de sesión
      post '/login', email: @user.email, password: "password"
      
      get '/select_system'
      
      expect(last_response).to be_ok
      expect(last_response.body).to include("select_system") # Asegúrate de que hay un contenido en la vista
    end
  
    it 'redirects unauthenticated users to the login page' do
      get '/select_system'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  end
  

  #Pruebas para la seleccion de sistema y lecciones
  context 'Level Selection and Lesson Display' do
  
    context 'GET /select_level/:system' do
    
      it 'renders the select_level page for authenticated users' do
        # Simula el inicio de sesión
        post '/login', email: @user.email, password: "password"
        
        get '/select_level/digestivo' # Cambia "digestivo" por el sistema que necesites
        
        expect(last_response).to be_ok
        expect(last_response.body).to include("select_level") # Asegúrate de que hay un contenido en la vista
      end
    
      it 'redirects unauthenticated users to the login page' do
        get '/select_level/digestivo' # Cambia "digestivo" por el sistema que necesites
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  
    context 'GET /lesson/:system/:level' do
      context 'when user is logged in' do
        it 'displays the correct lesson for level 1' do
          get '/lesson/ruby/1'
          
          expect(last_response).to be_ok
          expect(last_response.body).to include('Lesson for Level 1')
        end
  
        it 'displays the correct lesson for level 2' do
          get '/lesson/ruby/2'
          
          expect(last_response).to be_ok
          expect(last_response.body).to include('Lesson for Level 2')
        end
  
        it 'displays the correct lesson for level 3' do
          get '/lesson/ruby/3'
          
          expect(last_response).to be_ok
          expect(last_response.body).to include('Lesson for Level 3')
        end
  
        it 'redirects to select_system if level is invalid' do
          get '/lesson/ruby/4'
          
          expect(last_response).to be_ok
          expect(last_response.body).to include('select_system')
        end
      end
  
      context 'when user is not logged in' do
        it 'redirects to login page' do
          delete '/logout'
          get '/lesson/ruby/1'
  
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/login')
        end
      end
    end
  end
  

  #Pruebas para el nivel y juego
  context 'Gameplay Routes' do
  
    context 'POST /level/:level/start_play' do
    
      it 'allows the user to start the game for a completed level' do
        post '/level/1/start_play' # El nivel completado
    
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/play/question') # Asegúrate de que se redirige correctamente
      end
    
      it 'prevents the user from starting a higher level' do
        post '/level/2/start_play' # El nivel no completado
    
        expect(last_response).to be_ok
        expect(last_response.body).to include("Necesitas completar el nivel 1 antes de acceder a este nivel.") # Verifica el mensaje
      end
    
      it 'redirects unauthenticated users to the login page' do
        session.clear # Limpiar la sesión para simular un usuario no autenticado
    
        post '/level/1/start_play'
    
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/login')
      end
    end
  
    context 'GET /play/question' do
        it 'displays the current question' do
          get '/play/question'
          
          expect(last_response).to be_ok
          expect(last_response.body).to include(@question.content) # Verifica que el contenido de la pregunta esté en la respuesta
        end
      
        it 'redirects unauthenticated users to login' do
          session.clear # Limpia la sesión para simular un usuario no autenticado
      
          get '/play/question'
      
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/login')
        end
      
        it 'redirects to select_system if there are no more questions' do
          session[:current_question_index] = 1 # Simula que ya se han mostrado todas las preguntas
      
          get '/play/question'
      
          expect(last_response).to be_redirect
          expect(last_request.path).to eq('/select_system')
        end
      end
      
    
    context 'POST /play/question' do
      it 'increments correct answer count and shows success message for correct answer' do
        post '/play/question', option_id: @correct_option.id
  
        expect(last_response).to be_redirect
        follow_redirect!
        expect(session[:last_message]).to eq('¡Respuesta correcta!')
        expect(@question.reload.correc_count).to eq(1)
      end
  
      it 'increments incorrect answer count and shows error message for incorrect answer' do
        post '/play/question', option_id: @incorrect_option.id
  
        expect(last_response).to be_redirect
        follow_redirect!
        expect(session[:last_message]).to eq('Respuesta incorrecta. Vuelve a intentarlo.')
        expect(@question.reload.incorrect_count).to eq(1)
      end
  
      it 'shows an error message if no option is selected' do
        post '/play/question'
  
        expect(last_response).to be_ok
        expect(last_response.body).to include('Por favor, selecciona una opción antes de responder.')
      end
  
      it 'redirects to /finish_play if all questions are answered' do
        session[:current_question_index] = 1
        post '/play/question', option_id: @correct_option.id
  
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/finish_play')
      end
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

  # Prueba para avanzar a la siguiente pregunta después de responder correctamente
  context 'POST /play/question with correct answer' do
    it 'advances to the next question and shows a correct message' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Crear preguntas y opciones
      question1 = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      correct_option = Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question1)
      Option.create!(text: 'Producir hormonas', correct: false, question: question1)
  
      question2 = Question.create!(text: '¿Cuál es el órgano principal del sistema digestivo?', system: 'digestivo')
      Option.create!(text: 'Estómago', correct: true, question: question2)
      Option.create!(text: 'Hígado', correct: false, question: question2)
      
      # Iniciar juego
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo', current_question_index: 0 }
  
      # Responder la pregunta correctamente
      post '/play/question', option_id: correct_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }
      
      expect(last_response).to be_ok
      expect(last_response.body).to include('¡Respuesta correcta!')
      # Verifica que el índice de la pregunta se ha incrementado
      expect(last_request.env['rack.session']['current_question_index']).to eq(1)
    end
  end

  context 'POST /play/question with incorrect answer' do
    it 'shows the correct answer message and does not advance if the answer is incorrect' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Crear preguntas y opciones
      question1 = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      correct_option = Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question1)
      incorrect_option = Option.create!(text: 'Producir hormonas', correct: false, question: question1)

      # Iniciar juego
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo', current_question_index: 0 }

      # Responder la pregunta incorrectamente
      post '/play/question', option_id: incorrect_option.id, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }
      
      # Verificar el resultado
      expect(last_response).to be_ok
      expect(last_response.body).to include("Respuesta incorrecta. Vuelve a intentarlo")
      # Verifica que el índice de la pregunta no se ha incrementado
      expect(last_request.env['rack.session']['current_question_index']).to eq(0)
    end
  end

  # Prueba para enviar una respuesta sin seleccionar opción
  context 'POST /play/question without selecting an option' do
    it 'shows an error message and does not advance' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'

      # Crear preguntas y opciones
      question = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question)
      Option.create!(text: 'Producir hormonas', correct: false, question: question)

      # Iniciar el juego
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo', current_question_index: 0 }

      # Enviar la solicitud sin seleccionar ninguna opción
      post '/play/question', {}, 'rack.session' => { user_id: user.id, current_question_index: 0, system: 'digestivo' }

      expect(last_response).to be_ok
      expect(last_response.body).to include('Por favor, selecciona una opción antes de responder.')
      # Verificar que el índice de la pregunta no se ha incrementado
      expect(last_request.env['rack.session']['current_question_index']).to eq(0)
    end
  end

  describe 'Question Consultation and Evaluation Routes' do
  
    describe 'GET /question/incorrect/:n' do
      it 'displays n incorrect questions' do
        Question.create(text: 'Pregunta incorrecta', incorrect_count: 5, system: 'digestivo', level: 2)
        get '/question/incorrect/1'
  
        expect(last_response).to be_ok
        expect(last_response.body).to include('Pregunta incorrecta')
      end
    end
  
    describe 'GET /question/correct/:n' do
      it 'displays n correct questions' do
        Question.create(text: 'Pregunta correcta', correc_count: 5, system: 'digestivo', level: 2)
        get '/question/correct/1'
  
        expect(last_response).to be_ok
        expect(last_response.body).to include('Pregunta correcta')
      end
    end
  
    describe 'GET /finish_play' do
      it 'displays the finish play page with the last message' do
        session[:last_message] = '¡Juego finalizado!'
        get '/finish_play'
  
        expect(last_response).to be_ok
        expect(last_response.body).to include('¡Juego finalizado!')
      end
    end
  
    describe 'GET /ready_for_evaluation' do
      it 'displays the evaluation page with questions for the selected level' do
        Question.create(text: 'Pregunta de evaluación', system: 'digestivo', level: 2)
        get '/ready_for_evaluation'
  
        expect(last_response).to be_ok
        expect(last_response.body).to include('Pregunta de evaluación')
      end
    end
  
    describe 'POST /submit_evaluation' do
      context 'when user answers all questions correctly' do
        it 'unlocks the next level and shows the evaluation result' do
          post '/submit_evaluation', "question#{@question1.id}" => @correct_option1.id.to_s, "question#{@question2.id}" => @correct_option2.id.to_s
  
          expect(last_response).to be_ok
          expect(last_response.body).to include("Puntuación: 2/2")
          
          # Verificar si el nivel completado se incrementó en la base de datos
          updated_user = User.find(@user.id)
          expect(updated_user.level_completed).to include("3")
        end
      end
  
      context 'when user leaves some questions unanswered' do
        it 'shows a message to answer all questions' do
          post '/submit_evaluation', "question#{@question1.id}" => @correct_option1.id.to_s
  
          expect(last_response).to be_ok
          expect(last_response.body).to include("Por favor, selecciona una opción para cada pregunta.")
        end
      end
  
      context 'when user answers some questions incorrectly' do
        it 'shows the evaluation result with a lower score' do
          post '/submit_evaluation', "question#{@question1.id}" => @incorrect_option1.id.to_s, "question#{@question2.id}" => @correct_option2.id.to_s
  
          expect(last_response).to be_ok
          expect(last_response.body).to include("Puntuación: 1/2")
        end
      end
  
      context 'when user is not logged in' do
        it 'redirects to the login page' do
          delete '/logout'
          post '/submit_evaluation'
  
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq('/login')
        end
      end
    end
  
    describe 'GET /logout' do
      it 'clears the session and redirects to the home page' do
        get '/logout'
  
        expect(session[:user_id]).to be_nil
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
      end
    end
  end
  

  context 'GET /ready_for_evaluation' do
    it 'renders the evaluation page with the correct questions' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Crear preguntas para el sistema
      question1 = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      question2 = Question.create!(text: '¿Cuál es el órgano principal del sistema digestivo?', system: 'digestivo')

      # Iniciar sesión y establecer el sistema en la sesión
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo' }
      
      # Acceder a la ruta para la evaluación
      get '/ready_for_evaluation', {}, 'rack.session' => { user_id: user.id, system: 'digestivo' }

      expect(last_response).to be_ok
      expect(last_response.body).to include('¿Cuál es la función principal del sistema digestivo?')
      expect(last_response.body).to include('¿Cuál es el órgano principal del sistema digestivo?')
      expect(last_request.env['rack.session']['system']).to eq('digestivo')
    end
  end  

  context 'POST /submit_evaluation' do
    it 'processes the user answers and shows the evaluation result' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Crear preguntas y opciones
      question1 = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      correct_option1 = Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question1)
      Option.create!(text: 'Producir hormonas', correct: false, question: question1)

      question2 = Question.create!(text: '¿Cuál es el órgano principal del sistema digestivo?', system: 'digestivo')
      correct_option2 = Option.create!(text: 'Estómago', correct: true, question: question2)
      Option.create!(text: 'Hígado', correct: false, question: question2)

      # Simular las respuestas del usuario
      post '/submit_evaluation', {
        "question#{question1.id}" => correct_option1.id,
        "question#{question2.id}" => correct_option2.id
      }, 'rack.session' => { user_id: user.id, system: 'digestivo' }

      # Verificar el resultado
      expect(last_response).to be_ok
      expect(last_response.body).to include('Resultado de la Evaluación')
      expect(last_response.body).to include("Tu puntuación: 2 de 2") # Ajusta según el puntaje real
    end
  end

  context 'POST /submit_evaluation with unanswered questions' do
    it 'shows an error message when some questions are unanswered' do
      user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
      post '/login', username: 'testuser', email: 'test@example.com', password: 'password123'
      
      # Crear preguntas
      question1 = Question.create!(text: '¿Cuál es la función principal del sistema digestivo?', system: 'digestivo')
      question2 = Question.create!(text: '¿Cuál es el órgano principal del sistema digestivo?', system: 'digestivo')
  
      # Iniciar sesión y establecer el sistema en la sesión
      post '/start_play', {}, 'rack.session' => { user_id: user.id, system: 'digestivo' }
      
      # Enviar respuestas dejando una pregunta sin responder
      post '/submit_evaluation', {
        "question#{question1.id}" => Option.create!(text: 'Descomponer los alimentos en nutrientes', correct: true, question: question1).id
        # No se envía una respuesta para question2
      }, 'rack.session' => { user_id: user.id, system: 'digestivo' }
  
      expect(last_response).to be_ok
      expect(last_response.body).to include('Por favor, selecciona una opción para cada pregunta.')
      expect(last_response.body).to include('¿Cuál es el órgano principal del sistema digestivo?')
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
end