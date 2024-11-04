# frozen_string_literal: true

# helpers/user_helpers.rb
module UserHelpers
  def get_level(user, system)
    systems_list = %w[digestivo respiratorio circulatorio reproductor]
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)

    current_system_index && current_system_index < user_levels.size ? user_levels[current_system_index] : 1
  end

  def update_level(user, system, new_level)
    systems_list = %w[digestivo respiratorio circulatorio reproductor]
    user_levels = user.level_completed.present? ? user.level_completed.split(',').map(&:to_i) : [0] * systems_list.size
    current_system_index = systems_list.index(system)

    return unless current_system_index

    user_levels[current_system_index] = [new_level, 3].min
    user.update(level_completed: user_levels.join(','))
  end
end
