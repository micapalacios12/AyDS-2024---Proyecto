# frozen_string_literal: true

# modelos/option.rb

# La clase Option representa una opción de respuesta en una pregunta.
# Cada opción pertenece a una pregunta y puede ser correcta o incorrecta.
class Option < ActiveRecord::Base
  # Cada opción pertenece a una pregunta, lo cual establece una relación de clave foránea en la base de datos
  belongs_to :question

  # Método que devuelve el valor del atributo `correct` de la opción.
  # Este método actúa como un verificador de si la opción es correcta.
  def correct?
    correct
  end

  # Método para procesar la respuesta del usuario y actualizar el conteo de respuestas correctas o incorrectas
  # en la pregunta asociada.
  def submit_answer(user_answer)
    # Verifica que el parámetro user_answer sea una instancia de Option. Si no lo es, lanza un error.
    raise ArgumentError, 'user_answer debe ser una instancia de Option' unless user_answer.is_a?(Option)

    # Si esta opción es correcta y coincide con la respuesta del usuario,
    # incrementa el contador `correc_count` de la pregunta.
    if correct? && user_answer == self
      question.increment!(:correc_count) # Usa increment! para asegurarte de que guarda el valor en la misma línea

    # Si esta opción es incorrecta pero coincide con la respuesta del usuario,
    # incrementa el contador `incorrect_count` de la pregunta.
    elsif !correct? && user_answer == self
      question.increment!(:incorrect_count)
    end
  end
end
