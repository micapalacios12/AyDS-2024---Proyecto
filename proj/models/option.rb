class Option < ActiveRecord::Base
  # Establece la relación de pertenencia a una pregunta  
  belongs_to :question 
end
