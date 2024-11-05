# frozen_string_literal: true

# helpers/user_helpers.rb
module UserHelpers
    # Obtiene el nivel actual del usuario para un sistema específico
    def get_level(user, system)
      systems_list = ['digestivo', 'respiratorio', 'circulatorio', 'reproductor']
      user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [1] * systems_list.size
      current_system_index = systems_list.index(system)
      
      if current_system_index && current_system_index < user_levels.size
        puts "Nivel completado: #{user_levels[current_system_index]}"
        user_levels[current_system_index]
      else
        1 # Nivel predeterminado
      end
    end

    # Actualiza el nivel completado del usuario para un sistema específico
    def update_level(user, system, new_level)
      systems_list = ['digestivo', 'respiratorio', 'circulatorio', 'reproductor']
      user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [1] * systems_list.size
      current_system_index = systems_list.index(system)
      
      if current_system_index
        user_levels[current_system_index] = [new_level, 4].min # Limitar el nivel máximo a 4
        user.update(level_completed: user_levels.join(','))
      end
    end
end
