# frozen_string_literal: true

# Cambia el tipo de la columna `level_completed` en la tabla `users` de integer a string
# con un valor predeterminado de '1,1,1,1' para representar el progreso en múltiples niveles
class ChangeLevelCompletedToStringInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :level_completed, :string, default: '1,1,1,1'
  end
end
