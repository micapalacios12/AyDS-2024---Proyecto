# frozen_string_literal: true

# helpers/evaluation_helpers.rb
module EvaluationHelpers
  # Método para procesar las respuestas del usuario
  def process_evaluation_submission
    if session[:user_id]
      setup_evaluation_variables
      return show_unanswered_questions if unanswered_questions.any?

      calculate_score_and_update_level
    else
      redirect '/login'
    end
  end

  # Configura las variables necesarias para la evaluación
  def setup_evaluation_variables
    @score = 0
    @user = User.find(session[:user_id])
    @system = session[:system]
    @questions = get_questions_for_level(@system, session[:level])
  end

  # Verifica si hay preguntas sin responder
  def unanswered_questions
    @questions.select do |question|
      params["question#{question.id}"].nil? || params["question#{question.id}"].empty?
    end
  end

  # Muestra un mensaje si hay preguntas sin responder
  def show_unanswered_questions
    @message = 'Por favor, selecciona una opción para cada pregunta.'
    erb :evaluation, locals: { message: @message, questions: @questions }
  end

  # Calcula el puntaje del usuario y actualiza el nivel si corresponde
  def calculate_score_and_update_level
    @questions.each { |question| update_score_for_question(question) }
    check_and_update_level
    erb :evaluation_result, locals: { score: @score, questions: @questions }
  end

  # Actualiza el puntaje para una pregunta específica
  def update_score_for_question(question)
    selected_option_id = params["question#{question.id}"].to_i
    selected_option = Option.find(selected_option_id)
    @score += 1 if selected_option&.correct?
  end

  # Verifica y actualiza el nivel del usuario si ha respondido correctamente
  def check_and_update_level
    total_questions = @questions.count
    current_level = get_level(@user, @system)

    return unless @score == total_questions && session[:level].to_i == current_level

    next_level = [current_level + 1, 4].min
    update_level(@user, @system, next_level)
  end
end
