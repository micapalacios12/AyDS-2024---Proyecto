class Progress <ActiveRecord::Base
  belongs_to :user
  validates :system, presenc: true
  validates :level, inclusion: {in: [1, 2, 3]}
end