# frozen_string_literal: true

# Añade una columna `role` de tipo string a la tabla `users` con un valor predeterminado de 'user'
class AddRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :string, default: 'user'
  end
end
