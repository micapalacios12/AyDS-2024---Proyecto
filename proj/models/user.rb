# models/user.rb

require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }

end
