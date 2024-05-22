class Question < ActiveRecord::Base
    # Establece la relación de uno a muchos con las opciones y configura la eliminación en cascada  
    has_many :options, dependent: :destroy
  
     # Valida que el sistema esté presente
    validates :system, presence: true 

    # Valida que la pregunta esté presente
    validates :question, presence: true

    # Define una validación personalizada para verificar que al menos una opción esté marcada como correcta
    validate :validate_correct_answer
  
    private
  
    # Método para validar que al menos una opción esté marcada como correcta
    def validate_correct_answer
      # Verifica que al menos una opción esté marcada como correcta
      unless options.any?(&:correct?)
        # Agrega un error si ninguna opción está marcada como correcta
        errors.add(:base, "At least one option must be marked as correct")
      end
    end
  end