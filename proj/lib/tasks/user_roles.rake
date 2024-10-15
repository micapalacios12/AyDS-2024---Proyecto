namespace :users do
    desc 'Set role for existing users'
    task set_roles: :environment do
      User.reset_column_information # Actualiza el esquema por si cambió
  
      # Actualiza todos los usuarios que no tengan rol aún
      User.find_each do |user|
        user.update(role: 'user') unless user.role.present?
      end
  
      puts "All existing users have been assigned the role 'user'."
    end
  end
  