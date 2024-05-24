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

#Preguntas y respuestas del sistema digestivo

question1 = Question.create(
  system: 'digestivo',
  text: '¿Cúal es la función principal del sistema digestivo?'
)

Option.create([
  {text: 'Producir hormonas', correct: false, question_id: question1.id},
  {text: 'Descomponer alimentos en nutrientes', correct: true, question_id: question1.id},
  {text: 'Regular la temperatura corporal', correct: false, question_id: question1.id},
  {text: 'Transportar oxígeno a las células', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el órgano principal del sistema digestivo?'
)

Option.create([
  {text: 'Hígado', correct: false, question_id: question2.id},
  {text: 'Páncreas', correct: false, question_id: question2.id},
  {text: 'Intestino delgado', correct: true, question_id: question2.id},
  {text: 'Intestino grueso', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el proceso por el cual se absorben los nutrientes en el intestino delgado?'
)

Option.create([
  {text: 'Absorción pasiva', correct: false, question_id: question3.id},
  {text: 'Absorción activa', correct: true, question_id: question3.id},
  {text: 'Absorción selectiva', correct: false, question_id: question3.id},
  {text: 'Absorción difusa', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el proceso por el cual se eliminan los desechos del cuerpo?'
)

Option.create([
  {text: 'Diuresis', correct: false, question_id: question4.id},
  {text: 'Excreción', correct: true, question_id: question4.id},
  {text: 'Respiración', correct: false, question_id: question4.id},
  {text: 'Transpiración', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'digestivo',
  text: '¿Qué papel juega el páncreas en la digestión?'
)

Option.create([
  {text: 'Secrección de enzimas', correct: true, question_id: question5.id},
  {text: 'Secrección de hormonas', correct: false, question_id: question5.id},
  {text: 'Secrección de ácidos', correct: false, question_id: question5.id},
  {text: 'Secrección de sales', correct: false, question_id: question5.id}
])

#Preguntas y respuestas del sistema respiratorio

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
  text: '¿Cúal es el órgano principal del sistema respiratorio?'
)

Option.create([
  {text: 'El corazón', correct: false, question_id: question2.id},
  {text: 'El cerebro', correct: false, question_id: question2.id},
  {text: 'El hígado', correct: false, question_id: question2.id},
  {text: 'Los pulmones', correct: true, question_id: question2.id}
])

question3 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal de los alvéolos?'
)

Option.create([
  {text: 'Producir moco para atrapar particulas extrañas', correct: false, question_id: question3.id},
  {text: 'Permitir el intercambio de oxígeno y dióxido de carbono', correct: true, question_id: question3.id},
  {text: 'Producir sangre', correct: false, question_id: question3.id},
  {text: 'Producir hormonas', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'respiratorio',
  text: '¿Qué músculo es responsable de la respiración?'
)

Option.create([
  {text: 'El diafragma', correct: true, question_id: question4.id},
  {text: 'El músculo pectoral', correct: false, question_id: question4.id},
  {text: 'El músculo del brazo', correct: false, question_id: question4.id},
])

question5 = Question.create(
  system: 'respiratorio',
  text: '¿Que parte del sistema respiratorio se inflama durante un ataque de asma?'
)

Option.create([
  {text: 'Los alveolos', correct: false, question_id: question5.id},
  {text: 'Los bronquios', correct: true, question_id: question5.id},
  {text: 'Los pulmones', correct: false, question_id: question5.id},
  {text: 'Los bronquiolos', correct: false, question_id: question5.id}
])

#Preguntas y respuestas del sistema circulatorio

question1 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es el órgano principal del sistema circulatorio?'
)

Option.create([
  {text: 'El corazón', correct: true, question_id: question1.id},
  {text: 'Los pulmones', correct: false, question_id: question1.id},
  {text: 'Los riñones', correct: false, question_id: question1.id},
  {text: 'Los intestinos', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal del corazón?'
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question2.id},
  {text: 'Producir hormonas', correct: false, question_id: question2.id},
  {text: 'Bombear sangre', correct: true, question_id: question2.id},
  {text: 'Producir calor', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal de los vasos sanguíneos?'
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question3.id},
  {text: 'Producir hormonas', correct: false, question_id: question3.id},
  {text: 'Bombear sangre', correct: false, question_id: question3.id},
  {text: 'Transportar sangre', correct: true, question_id: question3.id}
])

question4 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal de los riñones?'
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question4.id},
  {text: 'Producir enzimas', correct: false, question_id: question4.id},
  {text: 'Producir bilis', correct: false, question_id: question4.id},
  {text: 'Filtrar sangre', correct: true, question_id: question4.id}
])

question5 = Question.create(
  system: 'circulatorio',
  text: '¿Qué es el pulso?'
)

Option.create([
  {text: 'La sangre que sale del corazón', correct: false, question_id: question5.id},
  {text: 'La sangre que entra al corazón', correct: false, question_id: question5.id},
  {text: 'La sangre que circula por el cuerpo', correct: false, question_id: question5.id},
  {text: 'La sangre que sale del corazón y entra al cuerpo', correct: true, question_id: question5.id}
])

#Preguntas y respuestas del sistema reproductor

question1 = Question.create(
  system: 'reproductor',
  text: '¿Cuál es la función principal del sistema reproductor?'
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question1.id},
  {text: 'Permitir la reproducción y asegurar la continuidad de la especie', correct: true, question_id: question1.id},
  {text: 'Producir calor', correct: false, question_id: question1.id},
  {text: 'Regular la temperatura corporal', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'reproductor',
  text: '¿Qué órganos componen el sistema reproductor femenino?'
)

Option.create([
  {text: 'Ovarios, trompas de Falopio, útero y vagina', correct: true, question_id: question2.id},
  {text: 'Testículos, conductos deferentes, vesículas seminales y pene', correct: false, question_id: question2.id},
  {text: 'Ovarios, trompas de Falopio, útero y clítoris', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'reproductor',
  text: '¿Qué es la fertilización?'
)

Option.create([
  {text: 'El proceso por el cual el óvulo es transportado por las trompas de Falopio', correct: false, question_id: question3.id},
  {text: 'El proceso por el cual el óvulo es transportado por el útero', correct: false, question_id: question3.id},
  {text: 'La unión del espermatozoide y el óvulo para formar un cigoto', correct: true, question_id: question3.id}
])

question4 = Question.create(
  system: 'reproductor',
  text: '¿Qué es la menstruación?'
)

Option.create([
  {text: 'El proceso por el cual el óvulo es transportado por el útero', correct: false, question_id: question4.id},
  {text: 'La liberación mensual de un óvulo del ovario', correct: false, question_id: question4.id},
  {text: 'El proceso mediante el cual el útero expulsa su revestimiento', correct: true, question_id: question4.id}
])

question5 = Question.create(
  system: 'reproductor',
  text: '¿Qué hormona es principalmente responsable de la regulación del ciclo menstrual?'
)

Option.create([
  {text: 'Testosterona', correct: false, question_id: question5.id},
  {text: 'Progesterona', correct: false, question_id: question5.id},
  {text: 'Estrógeno', correct: true, question_id: question5.id}

])
