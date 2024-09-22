class Lesson < ActiveRecord::Base
  validates :system, presence: true
  validates :level, presence: true, inclusion: { in: [1, 2, 3], message: "Level must be between 1 and 3" }
  validates :content, presence: true
end
