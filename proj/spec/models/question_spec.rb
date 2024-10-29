# spec/models/question_spec.rb
require 'spec_helper'
require './models/question'

RSpec.describe Question, type: :model do
  before(:each) do
    Question.destroy_all # Limpiar la base de datos antes de cada prueba
  end

  context 'validations' do
    it 'is not valid without a level' do
      question = Question.new(system: 'Test System', text: 'Test Question')
      expect(question).to_not be_valid
      expect(question.errors[:level]).to include("can't be blank")
    end
    it 'is valid with valid attributes' do
      # Test para verificar si una pregunta es válida con atributos válidos
      question = Question.new(system: 'Test System', text: 'Test Question')
      expect(question).to be_valid
    end

    it 'is not valid without a system' do
      # Test para verificar si una pregunta es inválida sin un sistema
      question = Question.new(text: 'Test Question')
      expect(question).to_not be_valid
      expect(question.errors[:system]).to include("can't be blank")
    end

    it 'is not valid without a text' do
      # Test para verificar si una pregunta es inválida sin texto
      question = Question.new(system: 'Test System')
      expect(question).to_not be_valid
      expect(question.errors[:text]).to include("can't be blank")
    end
  end

  context 'associations' do
    it 'has many options' do
      # Test para verificar la relación "has_many" con las opciones
      question = Question.new(system: 'Test System', text: 'Test Question')
      option1 = question.options.new(text: 'Option 1')
      option2 = question.options.new(text: 'Option 2')
      expect(question.options).to include(option1, option2)
    end

    it 'destroys associated options when destroyed' do
      # Test para verificar que las opciones asociadas se eliminan en cascada al eliminar la pregunta
      question = Question.create(system: 'Test System', text: 'Test Question')
      option1 = question.options.create(text: 'Option 1')
      option2 = question.options.create(text: 'Option 2')
      question.destroy
      expect(Option.where(id: [option1.id, option2.id])).to be_empty
    end
  end
end
