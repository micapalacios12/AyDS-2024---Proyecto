require 'bcrypt'
require_relative '../models/question'

require_relative '../models/option'


# Define una lista de usuarios con sus atributos
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'password123' },
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'password123' },
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'password123' }
]

# Itera sobre cada usuario en la lista
users.each do |u|
  unless User.exists?(username: u[:username]) || User.exists?(email: u[:email])
    # Crea un nuevo usuario en la base de datos utilizando los atributos proporcionados
    User.create!(
      names: u[:names],
      username: u[:username],
      email: u[:email],
      password: u[:password],
      password_confirmation: u[:password]
    )
  end
end

# Eliminar las preguntas y opciones existentes para evitar duplicados
Question.destroy_all
Option.destroy_all


question1 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal del sistema respiratorio?'
)

Option.create([
  {text: 'Transportar nutrientes a las células', correct: false, question_id: question1.id},
  {text: 'Intercambiar gases entre el cuerpo y el ambiente', correct: true, question_id: question1.id},
  {text: 'Producir hormonas', correct: false, question_id: question1.id},
  {text: 'Descomponer alimentos en nutrientes', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'respiratorio',
  text: '¿Pregunta random?'
)



Option.create([
  {text: 'incorecta', correct: false, question_id: question2.id},
  {text: 'incorecta', correct: false, question_id: question2.id},
  {text: 'incorrecta', correct: false, question_id: question2.id},
  {text: 'Correcta', correct: true, question_id: question2.id}
])

