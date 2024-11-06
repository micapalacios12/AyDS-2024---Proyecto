# frozen_string_literal: true

# Añade una columna de tipo string para almacenar la ruta del avatar en la tabla `users`
class AddAvatarToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar, :string
  end
end
