
require 'bcrypt'

class User < ActiveRecord::Base
  # Utiliza el módulo bcrypt para cifrar y validar contraseñas de forma segura
  has_secure_password

  # Valida que el nombre de usuario esté presente y sea único
  validates :username, presence: true, uniqueness: { message: 'Username already taken.' }

  # Valida que el email esté presente y sea único
  validates :email, presence: true, uniqueness: { message: 'Email already registered.' }

  # Valida que la contraseña esté presente y tenga al menos 8 caracteres
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  validates :avatar, presence: true, allow_nil: true
end
