class Option < ActiveRecord::Base
  belongs_to :question

  def correct?
    self.correct
  end

  def submit_answer(user_answer)
    unless user_answer.is_a?(Option)
      raise ArgumentError, "user_answer debe ser una instancia de Option"
    end

    puts "user_answer es de tipo: #{user_answer.class}" # Verifica el tipo
    if correct? && user_answer == self
      question.increment!(:correc_count)  # Usa increment! para asegurarte de que guarda el valor en la misma línea
    elsif !correct? && user_answer == self
      question.increment!(:incorrect_count)
    end
  end
end
