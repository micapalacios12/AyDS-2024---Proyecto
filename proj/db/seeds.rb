require 'bcrypt'

users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'password123' },
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'password123' },
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'password123' }
]

users.each do |u|
  User.create!(
    names: u[:names],
    username: u[:username],
    email: u[:email],
    password: u[:password],
    password_confirmation: u[:password]
  )
end




