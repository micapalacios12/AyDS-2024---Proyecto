# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require './models/user'
require './models/question'
require './models/option'

require_relative 'helpers/game_helpers'
require_relative 'helpers/user_helpers'
require_relative 'helpers/evaluation_helpers'

# Controladores
require_relative './controllers/admin_controller'
require_relative './controllers/user_controller'

# Montar controladores
use AdminController, path: '/admin'
use UserController, path: '/user'

enable :sessions # Habilita uso de sesiones
set :database_file, './config/database.yml'

# Página principal
get '/' do
  erb :home
end
