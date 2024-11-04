# frozen_string_literal: true

class AddLevelToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :level, :integer
  end
end
