class Outstanding < ActiveRecord::Base
  belongs_to :retro

  validates :description, presence: true, length:{minimum:2}
  validates :retro_id, presence: true
  #validates :issue_id, presence: true
  validates :assigned_to, presence: true

end