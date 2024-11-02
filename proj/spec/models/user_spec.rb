# spec/models/user_spec.rb
require 'spec_helper'
require './models/user'

# Describe el comportamiento de la clase User
RSpec.describe User, type: :model do
  # Antes de cada prueba, se limpia la base de datos para evitar efectos colaterales
  before(:each) do
    User.destroy_all # Limpiar los usuarios antes de cada prueba
  end

  # Métodos para completar niveles
  context 'level completion methods' do
    it 'returns the correct level completed for a system' do
      # Crea un usuario de prueba
      user = User.create(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'password')
      # Verifica que el nivel completado para el sistema 1 es 1
      expect(user.get_level_completed(1)).to eq(1)  
    end
  
    it 'sets the level completed for a system' do
      # Crea un usuario de prueba
      user = User.create(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'password')
      # Establece el nivel completado para el sistema 0
      user.set_level_completed(0, 2)  
      # Verifica que el nivel completado para el sistema 0 sea 2
      expect(user.get_level_completed(0)).to eq(2)
    end
  end
  
  # Validaciones del modelo User
  context 'validations' do
    it 'is valid with valid attributes' do
      # Verifica que un usuario es válido con atributos válidos
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
      # Verifica que un usuario es inválido sin un nombre de usuario
      user = User.new(names: 'Test User', email: 'testuser@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      # Verifica que un usuario es inválido cuando no se proporciona un correo electrónico
      user = User.new(names: 'Test User', username: 'testuser', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid without a password' do
      # Verifica que un usuario es inválido cuando no se proporciona una contraseña
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is not valid with a short password' do
      # Verifica que un usuario es inválido cuando se proporciona una contraseña demasiado corta
      user = User.new(names: 'Test User', username: 'testuser', email: 'testuser@example.com', password: 'short')
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it 'is not valid with a duplicate username' do
      # Crea un usuario de prueba para verificar duplicados de nombre de usuario
      User.create!(names: 'Test User', username: 'testuser', email: 'testuser1@example.com', password: 'password')
      user = User.new(names: 'Another User', username: 'testuser', email: 'testuser2@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:username]).to include("Username already taken.")
    end

    it 'is not valid with a duplicate email' do
      # Crea un usuario de prueba para verificar duplicados de correo electrónico
      User.create!(names: 'Test User', username: 'testuser1', email: 'testuser@example.com', password: 'password')
      user = User.new(names: 'Another User', username: 'testuser2', email: 'testuser@example.com', password: 'password')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("Email already registered.")
    end
  end

  # Métodos de rol
  context 'role methods' do
    it 'returns true for admin role' do
      # Crea un usuario con rol de admin
      user = User.create(names: 'Admin User', username: 'adminuser', email: 'admin@example.com', password: 'password', role: 'admin')
      # Verifica que el usuario tenga rol de admin
      expect(user.admin?).to be true
      expect(user.user?).to be false
    end
  
    it 'returns true for user role' do
      # Crea un usuario regular
      user = User.create(names: 'Regular User', username: 'regularuser', email: 'user@example.com', password: 'password')
      # Verifica que el usuario tenga rol de usuario
      expect(user.user?).to be true
      expect(user.admin?).to be false
    end
  end
end
