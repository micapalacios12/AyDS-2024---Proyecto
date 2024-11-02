# spec/models/question_spec.rb
require 'spec_helper'
require './models/question'

RSpec.describe Question, type: :model do
  before(:each) do
    Question.destroy_all # Limpiar la base de datos antes de cada prueba
  end

  let(:question) { Question.new(system: 'Digestivo', text: '¿Cúal es la función principal del sistema digestivo?', level: 1, correc_count: 0, incorrect_count: 0) }
  
  context 'validations' do
    it 'is not valid without a level' do
      question = Question.new(system: 'Digestivo', text: '¿Cúal es la función principal del sistema digestivo?')
      expect(question).not_to be_valid
    end
    
    it 'is valid with valid attributes' do
      expect(valid_question).to be_valid
    end

    it 'is not valid without a system' do
      question = Question.new(text: 'Test Question')
      expect(question).to_not be_valid
      expect(question.errors[:system]).to include("can't be blank")
    end

    it 'is not valid without a text' do
      question = Question.new(system: 'Test System')
      expect(question).to_not be_valid
      expect(question.errors[:text]).to include("can't be blank")
    end
  end

  context 'associations' do
    it 'has many options' do
      question = valid_question
      option1 = question.options.create(text: 'Option 1')
      option2 = question.options.create(text: 'Option 2')
      expect(question.options).to include(option1, option2)
    end

    it 'destroys associated options when destroyed' do
      question = valid_question
      option1 = question.options.create(text: 'Option 1')
      option2 = question.options.create(text: 'Option 2')
      expect { question.destroy }.to change { Option.count }.by(-2) # Verifica que se eliminen 2 opciones
    end

    it 'can access correc_count' do
      question = Question.create(system: 'Test', text: 'Test', level: 1, correc_count: 0, incorrect_count: 0)
      expect(question.correc_count).to eq(0)
    end
    
  end
end
