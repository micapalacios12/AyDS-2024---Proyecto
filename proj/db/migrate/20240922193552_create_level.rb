class AddLevelToQuestionsAndLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :level, :integer
    add_column :lessons, :level, :integer
  end
end
