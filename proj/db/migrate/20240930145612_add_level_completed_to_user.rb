# frozen_string_literal: true

class AddLevelCompletedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :level_completed, :integer, default: 1
  end
end
