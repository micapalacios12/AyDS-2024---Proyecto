# spec/models/option_spec.rb
require 'spec_helper'
require './models/option'

RSpec.describe Option, type: :model do
  before(:each) do
    Option.destroy_all # Limpiar la base de datos antes de cada prueba
  end

  context 'associations' do
    it 'belongs to a question' do
      # Test para verificar la asociación "belongs_to" con una pregunta
      question = Question.create(system: 'Test System', text: 'Test Question')
      option = question.options.create(text: 'Test Option')
      expect(option.question).to eq(question)
    end
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
  end
end
