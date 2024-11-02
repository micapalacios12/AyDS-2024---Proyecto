# spec/models/option_spec.rb
require 'spec_helper'
require './models/option'
require './models/question'
require './models/user'

RSpec.describe Option, type: :model do
  before(:each) do
    Option.destroy_all # Limpiar la base de datos antes de cada prueba
    Question.destroy_all
    User.destroy_all
  end

  let(:question) { Question.create(system: 'Digestivo', text: '¿Cúal es la función principal del sistema digestivo?', level: 1, correc_count: 0, incorrect_count: 0) }
  let(:correct_option) { question.options.create(text: 'Respuesta Correcta', correct: true) }
  let(:incorrect_option) { question.options.create(text: 'Respuesta Incorrecta', correct: false) }

  context 'methods' do
    it 'returns true for correct options' do
      option = Option.new(correct: true)
      expect(option.correct?).to be_truthy
    end

    it 'returns false for incorrect options' do
      option = Option.new(correct: false)
      expect(option.correct?).to be_falsey
    end

    it 'increments correct count when the answer is correct' do
      expect(question.correc_count).to eq(0)  # Confirmar que empieza en 0
      correct_option.submit_answer(correct_option)  # Debe incrementarse el contador correcto
      expect(question.reload.correc_count).to eq(1)  # Verificar que se incrementa a 1
      expect(question.reload.incorrect_count).to eq(0)  # Debería permanecer en 0
    end
    
    it 'increments incorrect count when the answer is incorrect' do
      expect(question.correc_count).to eq(0)  # Confirmar que empieza en 0
      incorrect_option.submit_answer(incorrect_option)  # Debe incrementarse el contador incorrecto
      expect(question.reload.incorrect_count).to eq(1)  # Verificar que se incrementa a 1
      expect(question.reload.correc_count).to eq(0)  # Debería permanecer en 0
    end
    
    it 'raises an error if user_answer is not an Option' do
      expect { correct_option.submit_answer("string_invalid") }.to raise_error(ArgumentError, "user_answer debe ser una instancia de Option")
    end
  end
end
