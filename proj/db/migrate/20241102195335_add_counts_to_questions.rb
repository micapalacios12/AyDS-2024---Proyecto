class AddCountsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :correc_count, :integer, default: 0
    add_column :questions, :incorrect_count, :integer, default: 0
  end
end
