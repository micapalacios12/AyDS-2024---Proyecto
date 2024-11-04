# frozen_string_literal: true

class Question < ActiveRecord::Base
  # Establece la relación de uno a muchos con las opciones y configura la eliminación en cascada
  has_many :options, dependent: :destroy

  # Valida que el sistema esté presente
  validates :system, presence: true

  # Valida que la pregunta esté presente
  validates :text, presence: true

  validates :level, presence: true

  # Métodos para listar las preguntas
  def self.listar_incorrectas(cantidad, veces)
    where('incorrect_count >= ?', veces) # Filtrar preguntas que se respondieron al menos 'veces' veces incorrectamente
      .order(incorrect_count: :desc) # Ordenar por incorrect_count en orden descendente
      .limit(cantidad) # Limitar el número de preguntas a la cantidad solicitada
  end

  def self.listar_correctas(cantidad, veces)
    where('correc_count >= ?', veces) # Filtrar preguntas que se respondieron al menos 'veces' veces correctamente
      .order(correc_count: :desc) # Ordenar por correct_count en orden descendente
      .limit(cantidad) # Limitar el número de preguntas a la cantidad solicitada
  end
end
