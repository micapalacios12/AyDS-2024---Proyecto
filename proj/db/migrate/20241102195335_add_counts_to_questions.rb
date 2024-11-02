class AddCountsToQuestions < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:questions, :correc_count)
      add_column :questions, :correc_count, :integer, default: 0
    end

    unless column_exists?(:questions, :incorrect_count)
      add_column :questions, :incorrect_count, :integer, default: 0
    end
  end
end
