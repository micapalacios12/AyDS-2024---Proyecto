# frozen_string_literal: true

# Define una migración para crear la tabla de usuarios
class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :names # Campo para almacenar el nombre completo del usuario
      t.string :username # Campo para almacenar el nombre de usuario único
      t.string :email # Campo para almacenar la dirección de correo electrónico única
      t.string :password_digest # Campo para almacenar el hash de la contraseña
      t.timestamps # Campos para registrar la fecha y hora de creación y actualización de cada registro
    end
  end
end
