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

  context 'methods' do
    it 'returns true for correct options' do
      # Test para verificar que el método "correct?" devuelve true para opciones correctas
      option = Option.new(correct: true)
      expect(option.correct?).to be_truthy
    end

    it 'returns false for incorrect options' do
      # Test para verificar que el método "correct?" devuelve false para opciones incorrectas
      option = Option.new(correct: false)
      expect(option.correct?).to be_falsey
    end

    it 'increments correct count when the answer is correct' do
      question = Question.create(system: 'Digestivo', text: '¿Cúal es la función principal del sistema digestivo?')
      option = question.options.create(text: 'Respuesta Correcta', correct: true)
      user = User.create(names: 'User Test', username: 'testuser', email: 'testuser@example.com', password: 'password')

      option.submit_answer(option)  # Simulando que el usuario selecciona la opción correcta

      expect(question.reload.correc_count).to eq(1)
      expect(question.reload.incorrect_count).to eq(0)
    end

    it 'increments incorrect count when the answer is incorrect' do
      question = Question.create(system: 'Digestivo', text: '¿Cúal es la función principal del sistema digestivo?')
      option = question.options.create(text: 'Respuesta Incorrecta', correct: false)
      user = User.create(names: 'User Test', username: 'testuser', email: 'testuser@example.com', password: 'password')

      option.submit_answer(option)  # Simulando que el usuario selecciona una opción incorrecta

      expect(question.reload.correc_count).to eq(0)
      expect(question.reload.incorrect_count).to eq(1)
    end
  end
end