# spec/models/option_spec.rb
require 'spec_helper'
require './models/option'
require './models/question'
require './models/user'

# Describe el comportamiento de la clase Option
RSpec.describe Option, type: :model do
  # Antes de cada prueba, se limpia la base de datos para evitar efectos colaterales
  before(:each) do
    Option.destroy_all # Limpiar las opciones antes de cada prueba
    Question.destroy_all # Limpiar las preguntas antes de cada prueba
    User.destroy_all # Limpiar los usuarios antes de cada prueba
  end

  # Configuración de pruebas: creación de una pregunta y opciones correctas e incorrectas
  let(:question) { Question.create(system: 'Digestivo', text: '¿Cuál es la función principal del sistema digestivo?', level: 1, correc_count: 0, incorrect_count: 0) }
  let(:correct_option) { question.options.create(text: 'Correcta', correct: true) }
  let(:incorrect_option) { question.options.create(text: 'Incorrecta', correct: false) }

  # Pruebas para el método #correct?
  describe '#correct?' do
    it 'returns true for correct options' do
      # Verifica que el método correct? devuelve true para opciones correctas
      expect(correct_option.correct?).to eq(true)
    end

    it 'returns false for incorrect options' do
      # Verifica que el método correct? devuelve false para opciones incorrectas
      expect(incorrect_option.correct?).to eq(false)
    end
  end

  # Pruebas para el método #submit_answer
  describe '#submit_answer' do
    context 'when the answer is correct' do
      it 'increments correc_count for the associated question' do
        # Verifica que el contador de respuestas correctas se incrementa en 1
        expect { correct_option.submit_answer(correct_option) }.to change { question.reload.correc_count }.by(1)
      end

      it 'does not increment incorrect_count' do
        # Verifica que el contador de respuestas incorrectas no se incrementa
        expect { correct_option.submit_answer(correct_option) }.not_to change { question.reload.incorrect_count }
      end
    end

    context 'when the answer is incorrect' do
      it 'increments incorrect_count for the associated question' do
        # Verifica que el contador de respuestas incorrectas se incrementa en 1
        expect { incorrect_option.submit_answer(incorrect_option) }.to change { question.reload.incorrect_count }.by(1)
      end

      it 'does not increment correc_count' do
        # Verifica que el contador de respuestas correctas no se incrementa
        expect { incorrect_option.submit_answer(incorrect_option) }.not_to change { question.reload.correc_count }
      end
    end

    context 'when submit_answer is called with an invalid user type' do
      it 'raises an error' do
        # Verifica que se lanza un error si se pasa un tipo de usuario no válido
        expect { correct_option.submit_answer("string") }.to raise_error(ArgumentError, "user_answer debe ser una instancia de Option")
      end
    end
  end
end
