# frozen_string_literal: true

# Añade una columna `level` de tipo integer a la tabla `questions`
class AddLevelToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :level, :integer
  end
end
