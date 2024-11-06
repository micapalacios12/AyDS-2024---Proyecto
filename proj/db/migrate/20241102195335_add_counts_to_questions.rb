# frozen_string_literal: true

# Añade las columnas `correct_count` e `incorrect_count` de tipo integer a la tabla `questions`
# Ambas tienen un valor predeterminado de 0 para el seguimiento de respuestas correctas e incorrectas
class AddCountsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :correc_count, :integer, default: 0
    add_column :questions, :incorrect_count, :integer, default: 0
  end
end
