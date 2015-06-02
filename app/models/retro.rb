class Retro < ActiveRecord::Base
  belongs_to :project
  has_many :issues

  validates :creator_id, presence: true
  validates :meeting_date, presence: true
  validates :project_id, presence: true
  validates :status, presence: true
end
