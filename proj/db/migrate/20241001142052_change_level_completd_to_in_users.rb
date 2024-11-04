# frozen_string_literal: true

class ChangeLevelCompletdToInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :level_completed, :string, default: '1,1,1,1'
  end
end
