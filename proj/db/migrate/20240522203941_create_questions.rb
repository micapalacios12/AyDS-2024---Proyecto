# Define una migración para crear la tabla de preguntas
class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :text # Campo para almacenar el texto de la pregunta
      t.string :system # Campo para almacenar el sistema al que pertenece la pregunta
      t.timestamps # Campos para registrar la fecha y hora de creación y actualización de cada pregunta
    end
  end
end
