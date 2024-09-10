class Lesson < ActiveRecord::Base
  validates :system, presence: true
  validates :level, presence: true
  validates :content, presence: true
end
