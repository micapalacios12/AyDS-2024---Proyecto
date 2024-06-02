
class Question < ActiveRecord::Base
  # Establece la relación de uno a muchos con las opciones y configura la eliminación en cascada  
  has_many :options, dependent: :destroy
  
  # Valida que el sistema esté presente
  validates :system, presence: true 

  # Valida que la pregunta esté presente
  validates :text, presence: true

end