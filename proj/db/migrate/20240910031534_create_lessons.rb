class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.string :system  # Nombre del sistema al que pertenece la lección (ej. 'Matemáticas')
      t.integer :level  # Nivel de la lección (1, 2, 3)
      t.string :content # Ruta del archivo PDF de la lección

      t.timestamps
    end
  end
end
