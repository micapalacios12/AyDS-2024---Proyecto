require 'bcrypt'

# Define una lista de usuarios con sus atributos
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'password123' },
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'password123' },
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'password123' }
]

# Itera sobre cada usuario en la lista
users.each do |u|
  # Crea un nuevo usuario en la base de datos utilizando los atributos proporcionados
  User.create!(
    names: u[:names],
    username: u[:username],
    email: u[:email],
    password: u[:password],
    password_confirmation: u[:password]
  )
end




