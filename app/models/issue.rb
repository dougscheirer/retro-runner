class Issue < ActiveRecord::Base
  belongs_to :retro
  validates :creator_id, presence: true
  validates :retro_id, presence: true
  validates :description, presence: true, length:{ minimum:2 }
  validates :issue_type, presence: true
end
