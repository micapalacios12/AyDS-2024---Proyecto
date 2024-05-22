class Option < ActiveRecord::Base
    # Establece la relación de pertenencia a una pregunta  
    belongs_to :question
  
    # Define una validación personalizada que se ejecuta al crear una opción
    validate :validate_max_options, on: :create
  
    private
     # Método para validar el número máximo de opciones asociadas a una pregunta  
    def validate_max_options
       # Verifica si la pregunta ya tiene el máximo de opciones permitidas
      if question.options.count >= 4
         # Agrega un error si la pregunta ya tiene el máximo de opciones
        errors.add(:base, "A question can have a maximum of 4 options")
      end
    end
  end