# frozen_string_literal: true

# Añade una columna `level_completed` de tipo integer a la tabla `users` con un valor predeterminado de 1
class AddLevelCompletedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :level_completed, :integer, default: 1
  end
end
