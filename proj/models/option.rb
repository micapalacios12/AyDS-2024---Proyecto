class Option < ActiveRecord::Base
  # Establece la relación de pertenencia a una pregunta
  belongs_to :question

  def correct?
    self.correct
  end

  def submit_answer(user)
    # Aquí iría la lógica para verificar si la respuesta es correcta
    if correct? && user == self
      # Si la respuesta es correcta, incrementa el contador de respuestas correctas
      question.increment(:correc_count)
    else
      # Si la respuesta no es correcta, incrementa el contador de respuestas incorrectas
      question.increment(:incorrect_count)
    end

    #Guarda los cambios en la pregunta
    question.save
  end
  
end