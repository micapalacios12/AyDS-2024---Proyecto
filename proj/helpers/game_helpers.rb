# frozen_string_literal: true

# helpers/game_helpers.rb
# Módulo que proporciona métodos de ayuda para gestionar la lógica del juego,
# incluyendo la obtención del usuario actual, preguntas para un nivel específico,
# y el manejo de respuestas en el juego.
module GameHelpers
  # Obtiene el usuario actual a partir de la sesión.
  # Devuelve el usuario si está autenticado, o `nil` si no lo está.
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Obtiene las preguntas para un sistema y nivel específicos.
  # @param system [String] El sistema (por ejemplo, 'digestivo').
  # @param level [Integer] El nivel del sistema.
  # @return [Array<Question>] Lista de preguntas correspondientes.
  def get_questions_for_level(system, level)
    Question.where(system: system, level: level)
  end

  # Obtiene el nivel actual completado de un usuario en un sistema específico.
  # @param user [User] El usuario cuya información de nivel se obtiene.
  # @param system [String] El sistema (por ejemplo, 'digestivo').
  # @return [Integer] El nivel completado del usuario en ese sistema, o 1 si no hay datos.
  def get_level(user, system)
    systems_list = %w[digestivo respiratorio circulatorio reproductor]
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)

    current_system_index && current_system_index < user_levels.size ? user_levels[current_system_index] : 1
  end

  # Actualiza el nivel completado de un usuario en un sistema específico.
  # @param user [User] El usuario cuyo nivel será actualizado.
  # @param system [String] El sistema al cual se actualizará el nivel.
  # @param new_level [Integer] El nuevo nivel completado.
  def update_level(user, system, new_level)
    systems_list = %w[digestivo respiratorio circulatorio reproductor]
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)

    return unless current_system_index

    # Limita el nivel máximo a 3 antes de guardarlo
    user_levels[current_system_index] = [new_level, 3].min
    user.update(level_completed: user_levels.join(','))
  end

  # Gestiona el flujo del juego para la pregunta actual.
  # Si hay una pregunta disponible, procesa la respuesta del usuario;
  # de lo contrario, redirige al final del juego.
  def handle_play_question
    @level = session[:level]
    @system = session[:system]
    @current_question_index = session[:current_question_index]
    @questions = get_questions_for_level(@system, @level)

    if @current_question_index < @questions.count
      @current_question = @questions[@current_question_index]
      process_user_answer
    else
      redirect '/finish_play'
    end
  end

  # Procesa la respuesta del usuario para una pregunta.
  # Si no se selecciona una opción, muestra un mensaje de error;
  # de lo contrario, maneja la respuesta seleccionada.
  def process_user_answer
    if params[:option_id].nil? || params[:option_id].empty?
      @message = 'Por favor, selecciona una opción antes de responder.'
      erb :play, locals: { message: @message }
    else
      selected_option_id = params[:option_id].to_i
      selected_option = Option.find_by(id: selected_option_id)
      selected_option ? handle_answer(selected_option) : invalid_option_message
    end
  end

  # Maneja la respuesta seleccionada y determina si es correcta o incorrecta.
  # @param selected_option [Option] La opción seleccionada por el usuario.
  def handle_answer(selected_option)
    if selected_option.correct?
      correct_answer_flow
    else
      incorrect_answer_flow
    end
  end

  # Maneja el flujo cuando el usuario selecciona una respuesta correcta.
  # Incrementa el índice de pregunta, actualiza los contadores y redirige a la siguiente pregunta.
  def correct_answer_flow
    @message = '¡Respuesta correcta!'
    session[:current_question_index] += 1
    @current_question.increment(:correc_count) # Incrementa el contador de respuestas correctas
    @current_question.save
    session[:last_message] = @message
    session[:current_question_index] < @questions.count ? redirect('/play/question') : redirect('/finish_play')
  end

  # Maneja el flujo cuando el usuario selecciona una respuesta incorrecta.
  # Muestra un mensaje de error y actualiza el contador de respuestas incorrectas.
  def incorrect_answer_flow
    @message = 'Respuesta incorrecta. Vuelve a intentarlo.'
    @current_question.increment(:incorrect_count)
    @current_question.save
    erb :play, locals: { message: @message }
  end

  # Muestra un mensaje cuando se selecciona una opción no válida.
  def invalid_option_message
    @message = 'Opción no válida.'
    erb :play, locals: { message: @message }
  end
end
