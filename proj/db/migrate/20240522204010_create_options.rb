# Define una migración para crear la tabla de opciones
class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.string :text # Campo para almacenar el texto de la opción
      t.boolean :correct, default: false # Campo booleano para indicar si la opción es correcta, por defecto es falso
      t.references :question, foreign_key: true # Campo de referencia a la pregunta a la que pertenece esta opción
      t.timestamps # Campos para registrar la fecha y hora de creación y actualización de cada opción
    end
  end
end

