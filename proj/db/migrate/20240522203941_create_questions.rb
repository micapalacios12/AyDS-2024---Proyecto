# frozen_string_literal: true

# Define una migración para crear la tabla de preguntas
class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :text # Campo para almacenar el texto de la pregunta
      t.string :system # Campo para almacenar el sistema al que pertenece la pregunta
      t.integer :level
      t.timestamps # Campos para registrar la fecha y hora de creación y actualización de cada pregunta
      t.integer :correc_count, default: 0
      t.integer :incorrect_count, default: 0
    end
  end
end
