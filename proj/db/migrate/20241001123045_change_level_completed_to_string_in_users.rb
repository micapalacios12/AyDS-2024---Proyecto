class ChangeLevelCompletedToStringInUsers < ActiveRecord::Migration[6.0]
    def change
      change_column :users, :level_completed, :string, default: "1,1,1,1"
    end
  end
  