
class Question < ActiveRecord::Base
  # Establece la relación de uno a muchos con las opciones y configura la eliminación en cascada  
  has_many :options, dependent: :destroy
  
  # Valida que el sistema esté presente
  validates :system, presence: true 

  # Valida que la pregunta esté presente
  validates :text, presence: true

  validates :level, presence: true

  #Metodos para listas las preguntas
  def self.listar_preguntas_incorrectas(n)
    order(incorrect_count: :desc).limit(n) || []
  end

  def self.listar_preguntas_correctas(n)
    order(correc_count: :desc).limit(n) || []
  end
end