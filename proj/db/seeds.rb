require 'bcrypt'
require_relative '../models/question'

require_relative '../models/option'

# Eliminar las preguntas y opciones existentes para evitar duplicados
Question.destroy_all
Option.destroy_all

#Preguntas y respuestas del sistema digestivo

question1 = Question.create(
  system: 'digestivo',
  text: '¿Cúal es la función principal del sistema digestivo?', 
  level: 1
)

Option.create([
  {text: 'Producir hormonas', correct: false, question_id: question1.id},
  {text: 'Descomponer alimentos en nutrientes', correct: true, question_id: question1.id},
  {text: 'Regular la temperatura corporal', correct: false, question_id: question1.id},
  {text: 'Transportar oxígeno a las células', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el órgano principal del sistema digestivo?',
  level: 1
)

Option.create([
  {text: 'Hígado', correct: false, question_id: question2.id},
  {text: 'Páncreas', correct: false, question_id: question2.id},
  {text: 'Intestino delgado', correct: true, question_id: question2.id},
  {text: 'Intestino grueso', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el proceso por el cual se absorben los nutrientes en el intestino delgado?',
  level: 1
)

Option.create([
  {text: 'Absorción pasiva', correct: false, question_id: question3.id},
  {text: 'Absorción activa', correct: true, question_id: question3.id},
  {text: 'Absorción selectiva', correct: false, question_id: question3.id},
  {text: 'Absorción difusa', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el proceso por el cual se eliminan los desechos del cuerpo?',
  level: 1
)

Option.create([
  {text: 'Diuresis', correct: false, question_id: question4.id},
  {text: 'Excreción', correct: true, question_id: question4.id},
  {text: 'Respiración', correct: false, question_id: question4.id},
  {text: 'Transpiración', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'digestivo',
  text: '¿Qué papel juega el páncreas en la digestión?',
  level: 1
)

Option.create([
  {text: 'Secrección de enzimas', correct: true, question_id: question5.id},
  {text: 'Secrección de hormonas', correct: false, question_id: question5.id},
  {text: 'Secrección de ácidos', correct: false, question_id: question5.id},
  {text: 'Secrección de sales', correct: false, question_id: question5.id}
])

#Preguntas y respuestas del sistema respiratorio

question6 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal del sistema respiratorio?',
  level: 1
)

Option.create([
  {text: 'Transportar nutrientes a las células', correct: false, question_id: question6.id},
  {text: 'Intercambiar gases entre el cuerpo y el ambiente', correct: true, question_id: question6.id},
  {text: 'Producir hormonas', correct: false, question_id: question6.id},
  {text: 'Descomponer alimentos en nutrientes', correct: false, question_id: question6.id}
])

question7 = Question.create(
  system: 'respiratorio',
  text: '¿Cúal es el órgano principal del sistema respiratorio?',
  level: 1
)

Option.create([
  {text: 'El corazón', correct: false, question_id: question7.id},
  {text: 'El cerebro', correct: false, question_id: question7.id},
  {text: 'El hígado', correct: false, question_id: question7.id},
  {text: 'Los pulmones', correct: true, question_id: question7.id}
])

question8 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal de los alvéolos?',
  level: 1
)

Option.create([
  {text: 'Producir moco para atrapar particulas extrañas', correct: false, question_id: question8.id},
  {text: 'Permitir el intercambio de oxígeno y dióxido de carbono', correct: true, question_id: question8.id},
  {text: 'Producir sangre', correct: false, question_id: question8.id},
  {text: 'Producir hormonas', correct: false, question_id: question8.id}
])

question9 = Question.create(
  system: 'respiratorio',
  text: '¿Qué músculo es responsable de la respiración?',
  level: 1
)

Option.create([
  {text: 'El diafragma', correct: true, question_id: question9.id},
  {text: 'El músculo pectoral', correct: false, question_id: question9.id},
  {text: 'El músculo del brazo', correct: false, question_id: question9.id},
  {text: 'El corazon', correct: false, question_id: question9.id}
])

question10 = Question.create(
  system: 'respiratorio',
  text: '¿Que parte del sistema respiratorio se inflama durante un ataque de asma?',
  level: 1
)

Option.create([
  {text: 'Los alveolos', correct: false, question_id: question10.id},
  {text: 'Los bronquios', correct: true, question_id: question10.id},
  {text: 'Los pulmones', correct: false, question_id: question10.id},
  {text: 'Los bronquiolos', correct: false, question_id: question10.id}
])

#Preguntas y respuestas del sistema circulatorio

question11 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es el órgano principal del sistema circulatorio?',
  level: 1
)

Option.create([
  {text: 'El corazón', correct: true, question_id: question11.id},
  {text: 'Los pulmones', correct: false, question_id: question11.id},
  {text: 'Los riñones', correct: false, question_id: question11.id},
  {text: 'Los intestinos', correct: false, question_id: question11.id}
])

question12 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal del corazón?',
  level: 1
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question12.id},
  {text: 'Producir hormonas', correct: false, question_id: question12.id},
  {text: 'Bombear sangre', correct: true, question_id: question12.id},
  {text: 'Producir calor', correct: false, question_id: question12.id}
])

question13 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal de los vasos sanguíneos?',
  level: 1
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question13.id},
  {text: 'Producir hormonas', correct: false, question_id: question13.id},
  {text: 'Bombear sangre', correct: false, question_id: question13.id},
  {text: 'Transportar sangre', correct: true, question_id: question13.id}
])

question14 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal de los riñones?',
  level: 1
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question14.id},
  {text: 'Producir enzimas', correct: false, question_id: question14.id},
  {text: 'Producir bilis', correct: false, question_id: question14.id},
  {text: 'Filtrar sangre', correct: true, question_id: question14.id}
])

question15 = Question.create(
  system: 'circulatorio',
  text: '¿Qué es el pulso?',
  level: 1
)

Option.create([
  {text: 'La sangre que sale del corazón', correct: false, question_id: question15.id},
  {text: 'La sangre que entra al corazón', correct: false, question_id: question15.id},
  {text: 'La sangre que circula por el cuerpo', correct: false, question_id: question15.id},
  {text: 'La sangre que sale del corazón y entra al cuerpo', correct: true, question_id: question15.id}
])

#Preguntas y respuestas del sistema reproductor

question16 = Question.create(
  system: 'reproductor',
  text: '¿Cuál es la función principal del sistema reproductor?',
  level: 1
)

Option.create([
  {text: 'Producir sangre', correct: false, question_id: question16.id},
  {text: 'Permitir la reproducción y asegurar la continuidad de la especie', correct: true, question_id: question16.id},
  {text: 'Producir calor', correct: false, question_id: question16.id},
  {text: 'Regular la temperatura corporal', correct: false, question_id: question16.id}
])

question17 = Question.create(
  system: 'reproductor',
  text: '¿Qué órganos componen el sistema reproductor femenino?',
  level: 1
)

Option.create([
  {text: 'Ovarios, trompas de Falopio, útero y vagina', correct: true, question_id: question17.id},
  {text: 'Testículos, conductos deferentes, vesículas seminales y pene', correct: false, question_id: question17.id},
  {text: 'Ovarios, trompas de Falopio, útero y clítoris', correct: false, question_id: question17.id},
  {text: 'Ovarios, trompas de Falopio, vagina y clítoris', correct: false, question_id: question17.id}
])

question18 = Question.create(
  system: 'reproductor',
  text: '¿Qué es la fertilización?',
  level: 1
)

Option.create([
  {text: 'El proceso por el cual el óvulo es transportado por las trompas de Falopio', correct: false, question_id: question18.id},
  {text: 'El proceso por el cual el óvulo es transportado por el útero', correct: false, question_id: question18.id},
  {text: 'La unión del espermatozoide y el óvulo para formar un cigoto', correct: true, question_id: question18.id},
  {text: 'La union del ovulo a las trompas de Falopio ', correct: false, question_id: question18.id}
])

question19 = Question.create(
  system: 'reproductor',
  text: '¿Qué es la menstruación?',
  level: 1
)

Option.create([
  {text: 'El proceso por el cual el óvulo es transportado por el útero', correct: false, question_id: question19.id},
  {text: 'La liberación mensual de un óvulo del ovario', correct: false, question_id: question19.id},
  {text: 'El proceso mediante el cual el útero expulsa su revestimiento(endometrio)', correct: true, question_id: question19.id},
  {text: 'El proceso de la union de espermatozoide y el ovulo', correct: false, question_id: question19.id}
])

question20 = Question.create(
  system: 'reproductor',
  text: '¿Qué hormona es principalmente responsable de la regulación del ciclo menstrual?',
  level: 1
)

Option.create([
  {text: 'Testosterona', correct: false, question_id: question20.id},
  {text: 'Estrógeno', correct: true, question_id: question20.id},
  {text: 'Progesterona', correct: false, question_id: question20.id},
  {text: 'Tiroxina', correct: false, question_id: question20.id}
])

#NIVEL 2

question1 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es la función principal de la cavidad oral (boca) en el sistema digestivo?',
  level: 2
)

Option.create([
  {text: 'Convierte los alimentos en bilis con ayuda de la saliva', correct: false, question_id: question1.id},
  {text: 'Convierte los alimentos en pequeños trozos con la ayuda de los dientes y la saliva', correct: true, question_id: question1.id},
  {text: 'Absorbe los nutrientes de los alimentos', correct: false, question_id: question1.id},
  {text: 'Almacena temporalmente los alimentos', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es la función del esófago en el sistema digestivo?',
  level: 2
)

Option.create([
  {text: 'Lleva los alimentos desde la boca hasta el estómago', correct: true, question_id: question2.id},
  {text: 'Mezcla los alimentos con jugo gástrico', correct: false, question_id: question2.id},
  {text: 'Absorbe las proteínas y los hidratos de carbono', correct: false, question_id: question2.id},
  {text: 'Convierte los alimentos en pequeños trozos', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'digestivo',
  text: '¿Qué función tiene el hígado en el proceso digestivo?',
  level: 2
)

Option.create([
  {text: 'Descompone alimentos y produce jugo gástrico', correct: false, question_id: question3.id},
  {text: 'Almacena los alimentos hasta que puedan ser digeridos', correct: false, question_id: question3.id},
  {text: 'Produce la bilis y elimina toxinas', correct: true, question_id: question3.id},
  {text: 'Absorbe el agua de los alimentos', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es la función del intestino delgado en el sistema digestivo?',
  level: 2
)

Option.create([
  {text: 'Absorbe la sal y el agua de los alimentos', correct: false, question_id: question4.id},
  {text: 'Digiere y absorbe proteínas, grasas e hidratos de carbono', correct: true, question_id: question4.id},
  {text: 'Almacena temporalmente las heces', correct: false, question_id: question4.id},
  {text: 'Descompone los alimentos con bilis', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'digestivo',
  text: '¿Qué función cumple el intestino grueso?',
  level: 2
)

Option.create([
  {text: 'Absorbe la sal y el agua de los alimentos, formando las heces', correct: true, question_id: question5.id},
  {text: 'Digiere las proteínas y los hidratos de carbono', correct: false, question_id: question5.id},
  {text: 'Almacena temporalmente las heces', correct: false, question_id: question5.id},
  {text: 'Produce jugo gástrico para descomponer los alimentos', correct: false, question_id: question5.id}
])


question1 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal del sistema respiratorio humano?',
  level: 2
)

Option.create([
  {text: 'Transportar oxígeno a las células y eliminar dióxido de carbono', correct: true, question_id: question1.id},
  {text: 'Filtrar el aire y convertirlo en nutrientes', correct: false, question_id: question1.id},
  {text: 'Almacenar oxígeno para el cuerpo', correct: false, question_id: question1.id},
  {text: 'Regular la temperatura corporal', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'respiratorio',
  text: '¿Por dónde entra el aire al cuerpo y cómo se prepara antes de llegar a los pulmones?',
  level: 2
)

Option.create([
  {text: 'Entra por los bronquios y se mezcla con los glóbulos rojos', correct: false, question_id: question2.id},
  {text: 'Entra por la nariz y la boca, donde se filtra y se calienta', correct: true, question_id: question2.id},
  {text: 'Entra directamente por los pulmones sin ningún tipo de filtración', correct: false, question_id: question2.id},
  {text: 'Entra por la tráquea y luego se almacena en los bronquiolos', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'respiratorio',
  text: '¿Cómo se realiza el intercambio de gases en los alvéolos?',
  level: 2
)

Option.create([
  {text: 'El dióxido de carbono entra en los alvéolos y el oxígeno sale hacia la sangre por un proceso de difusión', correct: true, question_id: question3.id},
  {text: 'El oxígeno se difunde desde los capilares hacia los bronquiolos, y el dióxido de carbono se almacena en las células', correct: false, question_id: question3.id},
  {text: 'Los alvéolos convierten el oxígeno en dióxido de carbono para que sea exhalado', correct: false, question_id: question3.id},
  {text: 'El oxígeno y el dióxido de carbono intercambian lugares directamente en la tráquea', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'respiratorio',
  text: '¿Qué características de los alvéolos los hacen ideales para el intercambio de gases?',
  level: 2
)

Option.create([
  {text: 'Tienen paredes gruesas y están cubiertos de capilares musculosos', correct: false, question_id: question4.id},
  {text: 'Tienen paredes delgadas, están húmedos y tienen una gran superficie lobulada', correct: true, question_id: question4.id},
  {text: 'Son rígidos, lo que les permite almacenar más oxígeno', correct: false, question_id: question4.id},
  {text: 'Son pequeños y están aislados de la sangre para evitar infecciones', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'respiratorio',
  text: '¿Qué gas es expulsado del cuerpo durante la exhalación?',
  level: 2
)

Option.create([
  {text: 'Oxígeno', correct: false, question_id: question5.id},
  {text: 'Nitrógeno', correct: false, question_id: question5.id},
  {text: 'Dióxido de carbono', correct: true, question_id: question5.id},
  {text: 'Monóxido de carbono', correct: false, question_id: question5.id}
])


question1 = Question.create(
  system: 'circulatorio',
  text: '¿Cuáles son las tres partes principales del sistema circulatorio humano y cuál es su función principal?',
  level: 2
)

Option.create([
  {text: 'Corazón, vasos sanguíneos y glóbulos rojos', correct: false, question_id: question1.id},
  {text: 'Corazón, vasos sanguíneos y sangre', correct: true, question_id: question1.id},
  {text: 'Corazón, pulmones y sangre', correct: false, question_id: question1.id},
  {text: 'Pulmones, arterias y venas', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'circulatorio',
  text: 'Describe el recorrido de la sangre a través del corazón, mencionando las aurículas, los ventrículos y su paso por los pulmones.',
  level: 2
)

Option.create([
  {text: 'La sangre entra por el ventrículo derecho, pasa por las aurículas y llega a los pulmones', correct: false, question_id: question2.id},
  {text: 'La sangre entra por la aurícula derecha, pasa por el ventrículo derecho, va a los pulmones, regresa a la aurícula izquierda y sale por el ventrículo izquierdo', correct: true, question_id: question2.id},
  {text: 'La sangre entra por la aurícula izquierda y pasa por los ventrículos hasta salir por la aurícula derecha', correct: false, question_id: question2.id},
  {text: 'La sangre entra en los pulmones, luego pasa por las aurículas y sale por los ventrículos', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'circulatorio',
  text: 'Explica las funciones de los cuatro componentes principales de la sangre.',
  level: 2
)

Option.create([
  {text: 'Glóbulos rojos transportan oxígeno, glóbulos blancos combaten infecciones, plaquetas coagulan y plasma es el líquido en el que flotan', correct: true, question_id: question3.id},
  {text: 'Plaquetas transportan oxígeno, glóbulos rojos combaten infecciones, plasma coagula y glóbulos blancos son el líquido', correct: false, question_id: question3.id},
  {text: 'Glóbulos blancos transportan oxígeno, plasma combate infecciones, plaquetas coagulan y glóbulos rojos son el líquido', correct: false, question_id: question3.id},
  {text: 'Plasma transporta oxígeno, glóbulos rojos combaten infecciones, glóbulos blancos coagulan y plaquetas son el líquido', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'circulatorio',
  text: '¿Qué diferencias existen entre los tres tipos de vasos sanguíneos (arterias, venas y capilares) en cuanto a su estructura y función?',
  level: 2
)

Option.create([
  {text: 'Las arterias llevan sangre al corazón, las venas sacan sangre y los capilares intercambian gases', correct: false, question_id: question4.id},
  {text: 'Las arterias llevan sangre lejos del corazón, las venas traen la sangre de vuelta al corazón y los capilares permiten el intercambio de sustancias', correct: true, question_id: question4.id},
  {text: 'Las arterias y venas son lo mismo, y los capilares solo transportan oxígeno', correct: false, question_id: question4.id},
  {text: 'Las venas y arterias llevan sangre oxigenada, mientras que los capilares transportan dióxido de carbono', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'circulatorio',
  text: '¿Cómo se lleva a cabo un análisis de sangre para separar sus componentes, y cuál es el propósito de esta separación?',
  level: 2
)

Option.create([
  {text: 'La sangre se separa usando una centrífuga, que divide sus componentes para análisis detallado', correct: true, question_id: question5.id},
  {text: 'La sangre se separa dejando reposar el líquido hasta que los componentes se dividan por peso', correct: false, question_id: question5.id},
  {text: 'La sangre no se separa en análisis, sino que se examina directamente', correct: false, question_id: question5.id},
  {text: 'El propósito es descartar componentes que no sean necesarios para el análisis', correct: false, question_id: question5.id}
])

question1 = Question.create(
  system: 'reproductor',
  text: '¿Qué es un aparato reproductor?',
  level: 2
)

Option.create([
  {text: 'Conjunto de órganos y estructuras involucrados en la reproducción', correct: true, question_id: question1.id},
  {text: 'Sistema encargado de la digestión de alimentos', correct: false, question_id: question1.id},
  {text: 'Conjunto de músculos y huesos que soportan el cuerpo', correct: false, question_id: question1.id},
  {text: 'Órganos que filtran la sangre y eliminan toxinas', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'reproductor',
  text: '¿Cuál es la función principal del aparato reproductor femenino?',
  level: 2
)

Option.create([
  {text: 'Producir y almacenar espermatozoides', correct: false, question_id: question2.id},
  {text: 'Permitir la reproducción en las mujeres a través de la producción de óvulos', correct: true, question_id: question2.id},
  {text: 'Transportar sangre por el cuerpo', correct: false, question_id: question2.id},
  {text: 'Almacenar nutrientes para el crecimiento del feto', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'reproductor',
  text: '¿Qué función cumple el útero en el aparato reproductor femenino?',
  level: 2
)

Option.create([
  {text: 'Almacena los óvulos hasta que sean fertilizados', correct: false, question_id: question3.id},
  {text: 'Lugar donde se implanta y crece el óvulo fertilizado durante el embarazo', correct: true, question_id: question3.id},
  {text: 'Produce las hormonas responsables del ciclo menstrual', correct: false, question_id: question3.id},
  {text: 'Funciona como una barrera protectora para el feto', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'reproductor',
  text: '¿Qué función tienen los testículos en el aparato reproductor masculino?',
  level: 2
)

Option.create([
  {text: 'Producen espermatozoides, las células reproductivas masculinas', correct: true, question_id: question4.id},
  {text: 'Almacenan y transportan la orina', correct: false, question_id: question4.id},
  {text: 'Producen la secreción que forma parte del semen', correct: false, question_id: question4.id},
  {text: 'Producen las hormonas responsables del ciclo menstrual', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'reproductor',
  text: '¿Cuál es un hábito de higiene importante para cuidar el aparato reproductor?',
  level: 2
)

Option.create([
  {text: 'Lavar diariamente el área genital con agua y jabón suave', correct: true, question_id: question5.id},
  {text: 'Usar perfumes y lociones en el área genital', correct: false, question_id: question5.id},
  {text: 'Evitar secar la zona genital después de lavarla', correct: false, question_id: question5.id},
  {text: 'Usar ropa interior de materiales sintéticos', correct: false, question_id: question5.id}
])


#NIVEL 3

question1 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el proceso mediante el cual el sistema digestivo convierte la comida en energía para el cuerpo?',
  level: 3
)

Option.create([
  {text: 'Descompone la comida en nutrientes que son absorbidos y usados como energía', correct: true, question_id: question1.id},
  {text: 'Convierte la comida directamente en grasa para que el cuerpo la utilice', correct: false, question_id: question1.id},
  {text: 'Descompone la comida en pequeñas partes para ser eliminada inmediatamente del cuerpo', correct: false, question_id: question1.id},
  {text: 'Desintegra los alimentos por completo para convertirlos en agua', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'digestivo',
  text: '¿Qué función cumple el intestino delgado en el sistema digestivo?',
  level: 3
)

Option.create([
  {text: 'Absorbe nutrientes de los alimentos descompuestos y los transfiere al hígado', correct: true, question_id: question2.id},
  {text: 'Descompone los alimentos usando jugos gástricos', correct: false, question_id: question2.id},
  {text: 'Convierte los alimentos en desechos para ser eliminados', correct: false, question_id: question2.id},
  {text: 'Almacena los nutrientes de los alimentos hasta que el cuerpo los necesite', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'digestivo',
  text: '¿Cómo contribuye el hígado al proceso digestivo?',
  level: 3
)

Option.create([
  {text: 'El hígado procesa los nutrientes absorbidos, los almacena o los convierte en sustancias útiles para el cuerpo', correct: true, question_id: question3.id},
  {text: 'El hígado descompone la comida con jugos gástricos', correct: false, question_id: question3.id},
  {text: 'El hígado filtra las toxinas antes de que los alimentos lleguen al estómago', correct: false, question_id: question3.id},
  {text: 'El hígado descompone los desechos en el intestino grueso', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'digestivo',
  text: '¿Qué sucede con la comida una vez que llega al intestino grueso?',
  level: 3
)

Option.create([
  {text: 'El intestino grueso absorbe agua y forma los desechos que serán eliminados del cuerpo', correct: true, question_id: question4.id},
  {text: 'El intestino grueso descompone los nutrientes y los convierte en energía', correct: false, question_id: question4.id},
  {text: 'El intestino grueso almacena los desechos hasta que sean eliminados por el hígado', correct: false, question_id: question4.id},
  {text: 'El intestino grueso convierte los desechos en nutrientes utilizables', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'digestivo',
  text: '¿Cuál es el papel de los jugos gástricos en el estómago durante la digestión?',
  level: 3
)

Option.create([
  {text: 'Descomponen la comida en una papilla que el cuerpo puede utilizar', correct: true, question_id: question5.id},
  {text: 'Absorben nutrientes esenciales directamente en el estómago', correct: false, question_id: question5.id},
  {text: 'Convierte los alimentos en energía directamente', correct: false, question_id: question5.id},
  {text: 'Convierte los desechos en agua antes de enviarlos al intestino', correct: false, question_id: question5.id}
])

question1 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal del sistema respiratorio?',
  level: 3
)

Option.create([
  {text: 'Intercambiar gases con el medio ambiente', correct: true, question_id: question1.id},
  {text: 'Filtrar la sangre para eliminar toxinas', correct: false, question_id: question1.id},
  {text: 'Controlar la temperatura corporal', correct: false, question_id: question1.id},
  {text: 'Almacenar oxígeno para uso futuro', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'respiratorio',
  text: '¿Qué papel juegan los bronquios en el sistema respiratorio?',
  level: 3
)

Option.create([
  {text: 'Conducen el aire desde la laringe hasta la tráquea', correct: false, question_id: question2.id},
  {text: 'Distribuyen el aire entre los dos pulmones', correct: true, question_id: question2.id},
  {text: 'Son responsables del intercambio de gases en los pulmones', correct: false, question_id: question2.id},
  {text: 'Filtran el aire antes de que llegue a los pulmones', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'respiratorio',
  text: '¿Dónde se lleva a cabo el intercambio de gases en el sistema respiratorio?',
  level: 3
)

Option.create([
  {text: 'En la tráquea', correct: false, question_id: question3.id},
  {text: 'En los pulmones', correct: true, question_id: question3.id},
  {text: 'En la faringe', correct: false, question_id: question3.id},
  {text: 'En la laringe', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'respiratorio',
  text: '¿Cuál es la función principal de la tráquea en el sistema respiratorio?',
  level: 3
)

Option.create([
  {text: 'Conducir el aire desde la faringe hasta los bronquios', correct: true, question_id: question4.id},
  {text: 'Almacenar aire para uso posterior', correct: false, question_id: question4.id},
  {text: 'Filtrar el aire y eliminar partículas dañinas', correct: false, question_id: question4.id},
  {text: 'Ayudar en la producción de la voz', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'respiratorio',
  text: '¿Cómo participa el diafragma en el proceso respiratorio?',
  level: 3
)

Option.create([
  {text: 'Se contrae para permitir la entrada de aire a los pulmones', correct: true, question_id: question5.id},
  {text: 'Ayuda a distribuir el oxígeno entre los órganos', correct: false, question_id: question5.id},
  {text: 'Filtra el aire que ingresa a los pulmones', correct: false, question_id: question5.id},
  {text: 'Almacena el dióxido de carbono antes de la exhalación', correct: false, question_id: question5.id}
])

question1 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la función principal del sistema circulatorio?',
  level: 3
)

Option.create([
  {text: 'Transportar y bombear sangre por todo el cuerpo', correct: true, question_id: question1.id},
  {text: 'Filtrar la sangre y eliminar toxinas', correct: false, question_id: question1.id},
  {text: 'Almacenar nutrientes para su uso futuro', correct: false, question_id: question1.id},
  {text: 'Producir glóbulos rojos y blancos', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es el papel de las arterias en el sistema circulatorio?',
  level: 3
)

Option.create([
  {text: 'Transportar sangre desde el corazón hacia diferentes partes del cuerpo', correct: true, question_id: question2.id},
  {text: 'Transportar sangre desde el cuerpo hacia el corazón', correct: false, question_id: question2.id},
  {text: 'Conectar las venas y los capilares', correct: false, question_id: question2.id},
  {text: 'Almacenar oxígeno para los órganos', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'circulatorio',
  text: '¿Qué función cumplen los capilares en el sistema circulatorio?',
  level: 3
)

Option.create([
  {text: 'Conectar las arterias con las venas y hacer circular sangre, nutrientes y oxígeno a las células', correct: true, question_id: question3.id},
  {text: 'Transportar sangre desde el corazón a los órganos principales', correct: false, question_id: question3.id},
  {text: 'Almacenar sangre oxigenada hasta que sea necesaria', correct: false, question_id: question3.id},
  {text: 'Filtrar los desechos del torrente sanguíneo', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'circulatorio',
  text: '¿Cuál es la diferencia principal entre las venas y las arterias en el sistema circulatorio?',
  level: 3
)

Option.create([
  {text: 'Las venas transportan sangre hacia el corazón, mientras que las arterias la transportan fuera del corazón', correct: true, question_id: question4.id},
  {text: 'Las arterias solo transportan oxígeno, mientras que las venas solo transportan dióxido de carbono', correct: false, question_id: question4.id},
  {text: 'Las arterias conectan los capilares con los órganos, mientras que las venas conectan los capilares con el corazón', correct: false, question_id: question4.id},
  {text: 'Las venas tienen paredes más gruesas que las arterias para soportar la alta presión sanguínea', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'circulatorio',
  text: '¿Qué órgano principal bombea la sangre en el sistema circulatorio?',
  level: 3
)

Option.create([
  {text: 'El corazón', correct: true, question_id: question5.id},
  {text: 'Los pulmones', correct: false, question_id: question5.id},
  {text: 'El hígado', correct: false, question_id: question5.id},
  {text: 'Los riñones', correct: false, question_id: question5.id}
])

question1 = Question.create(
  system: 'reproductor',
  text: '¿Dónde ocurre comúnmente la fertilización en el aparato reproductor femenino?',
  level: 3
)

Option.create([
  {text: 'En las trompas de Falopio', correct: true, question_id: question1.id},
  {text: 'En el útero', correct: false, question_id: question1.id},
  {text: 'En los ovarios', correct: false, question_id: question1.id},
  {text: 'En la vagina', correct: false, question_id: question1.id}
])

question2 = Question.create(
  system: 'reproductor',
  text: '¿Cuál es la función principal del útero en el sistema reproductor femenino?',
  level: 3
)

Option.create([
  {text: 'Almacenar los óvulos producidos por los ovarios', correct: false, question_id: question2.id},
  {text: 'Preparar su revestimiento para nutrir un óvulo fertilizado', correct: true, question_id: question2.id},
  {text: 'Transportar los óvulos hacia la vagina', correct: false, question_id: question2.id},
  {text: 'Producir hormonas para regular el ciclo menstrual', correct: false, question_id: question2.id}
])

question3 = Question.create(
  system: 'reproductor',
  text: '¿Qué órgano produce y almacena los óvulos en el sistema reproductor femenino?',
  level: 3
)

Option.create([
  {text: 'El útero', correct: false, question_id: question3.id},
  {text: 'El ovario', correct: true, question_id: question3.id},
  {text: 'Las trompas de Falopio', correct: false, question_id: question3.id},
  {text: 'El cuello uterino', correct: false, question_id: question3.id}
])

question4 = Question.create(
  system: 'reproductor',
  text: '¿Qué función cumplen los conductos deferentes en el sistema reproductor masculino?',
  level: 3
)

Option.create([
  {text: 'Transportan el esperma maduro fuera de los testículos', correct: true, question_id: question4.id},
  {text: 'Producen el líquido seminal', correct: false, question_id: question4.id},
  {text: 'Conectan la uretra con la próstata', correct: false, question_id: question4.id},
  {text: 'Filtran la orina antes de que llegue al pene', correct: false, question_id: question4.id}
])

question5 = Question.create(
  system: 'reproductor',
  text: '¿Qué órgano produce el líquido seminal que forma la mayor parte del semen en el sistema reproductor masculino?',
  level: 3
)

Option.create([
  {text: 'La vesícula seminal', correct: true, question_id: question5.id},
  {text: 'El pene', correct: false, question_id: question5.id},
  {text: 'Los testículos', correct: false, question_id: question5.id},
  {text: 'La próstata', correct: false, question_id: question5.id}
])
