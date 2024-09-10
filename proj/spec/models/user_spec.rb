# spec/models/user_spec.rb
require 'spec_helper'
require './models/user'

RSpec.describe User, type: :model do
  before(:each) do
    User.destroy_all # Limpiar la base de datos antes de cada prueba
  end

  context 'validations' do
    it 'is valid with valid attributes' do
        # Test para verificar si un usuario es válido con atributos válidos
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
         # Test para verificar si un usuario es inválido sin un nombre de usuario
      user = User.new(names: 'Test User', email: 'testuser@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is not valid without an email' do
       #test para verifica si un usuario es inválido cuando no se proporciona un correo electrónico
      user = User.new(names: 'Test User', username: 'testuser', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid without a password' do
        #test para verifica si un usuario es invalido cuando no se proporciona una constraseña
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is not valid with a short password' do
        #test para verfificar si un usuario es invalido cuando se proporciona una constraseña demasiado corta.
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'short')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it 'is not valid with a duplicate username' do
        #test para verificar si un usuario es invalido cuando se intenta crear un usuario con un nombre de usuario que ya existe.
      User.create!(names: 'Test User', username: 'testuser', email: 'testuser1@example.com', password: 'password')
      user = User.new(names: 'Another User', username: 'testuser', email: 'testuser2@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("Username already taken.")
    end

    it 'is not valid with a duplicate email' do
        #test para verificar si un usuario es invalido cuando se intenta crear un usuario con un correo electronico que ya existe.
      User.create!(names: 'Test User', username: 'testuser1', email: 'testuser@example.com', password: 'password')
      user = User.new(names: 'Another User', username: 'testuser2', email: 'testuser@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("Email already registered.")

    end
  end
end
