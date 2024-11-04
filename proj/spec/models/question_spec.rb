# frozen_string_literal: true

# spec/models/question_spec.rb
require 'spec_helper' # Carga la configuración de pruebas
require './models/question' # Carga el modelo Question para realizar las pruebas

# Inicia las pruebas para el modelo Question
RSpec.describe Question, type: :model do
  before(:each) do
    Question.destroy_all # Limpia la base de datos antes de cada prueba para evitar interferencias entre ellas
  end

  # Define una instancia válida de Question para utilizar en las pruebas
  let(:valid_question) do
    Question.create!(system: 'Digestivo', text: '¿Cuál es la función principal del sistema digestivo?', level: 1,
                     correc_count: 0, incorrect_count: 0)
  end

  # Pruebas de validaciones
  context 'validations' do
    it 'is not valid without a level' do
      question = Question.new(system: 'Digestivo', text: '¿Cuál es la función principal del sistema digestivo?')
      expect(question).not_to be_valid # Verifica que la pregunta no sea válida sin el atributo level
    end

    it 'is valid with valid attributes' do
      expect(valid_question).to be_valid # Verifica que una pregunta con atributos válidos sea válida
    end

    it 'is not valid without a system' do
      question = Question.new(text: 'Test Question', level: 1)
      expect(question).to_not be_valid # Verifica que la pregunta no sea válida sin el atributo system
      expect(question.errors[:system]).to include("can't be blank") # Comprueba el mensaje de error correspondiente
    end

    it 'is not valid without a text' do
      question = Question.new(system: 'Test System', level: 1)
      expect(question).to_not be_valid # Verifica que la pregunta no sea válida sin el atributo text
      expect(question.errors[:text]).to include("can't be blank") # Comprueba el mensaje de error correspondiente
    end
  end

  # Pruebas de asociaciones
  context 'associations' do
    it 'has many options' do
      question = valid_question
      option1 = question.options.create!(text: 'Option 1')
      option2 = question.options.create!(text: 'Option 2')
      expect(question.options).to include(option1, option2) # Verifica que se pueden crear opciones asociadas a la pregunta
    end

    it 'destroys associated options when destroyed' do
      question = valid_question
      question.options.create!(text: 'Option 1')
      question.options.create!(text: 'Option 2')
      expect { question.destroy }.to change {
        Option.count
      }.by(-2) # Verifica que al eliminar la pregunta, también se eliminen sus opciones asociadas
    end

    it 'can access correc_count' do
      question = valid_question
      expect(question.correc_count).to eq(0) # Verifica que el atributo correc_count se pueda acceder y sea inicialmente 0
    end
  end

  # Pruebas de los métodos listar_incorrectas y listar_correctas
  context 'listar_incorrectas and listar_correctas methods' do
    # Crea tres preguntas con distintos valores de correc_count e incorrect_count para probar los métodos de listado
    let!(:question1) do
      Question.create!(system: 'Digestivo', text: 'Pregunta 1', level: 1, correc_count: 2, incorrect_count: 3)
    end
    let!(:question2) do
      Question.create!(system: 'Digestivo', text: 'Pregunta 2', level: 1, correc_count: 1, incorrect_count: 5)
    end
    let!(:question3) do
      Question.create!(system: 'Digestivo', text: 'Pregunta 3', level: 1, correc_count: 5, incorrect_count: 1)
    end

    # Prueba del método listar_incorrectas
    describe '.listar_incorrectas' do
      it 'returns questions with incorrect_count greater than or equal to the specified value' do
        result = Question.listar_incorrectas(2, 3) # Busca preguntas con incorrect_count >= 3 y límite de 2 resultados
        expect(result).to include(question1, question2) # Verifica que las preguntas 1 y 2 estén en los resultados
        expect(result).not_to include(question3) # Verifica que la pregunta 3 no esté en los resultados
      end
    end

    # Prueba del método listar_correctas
    describe '.listar_correctas' do
      it 'returns questions with correc_count greater than or equal to the specified value' do
        result = Question.listar_correctas(2, 3) # Busca preguntas con correc_count >= 3 y límite de 2 resultados
        expect(result).to include(question3) # Verifica que la pregunta 3 esté en los resultados
        expect(result).not_to include(question1, question2) # Verifica que las preguntas 1 y 2 no estén en los resultados
      end
    end
  end
end
