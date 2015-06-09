class Retro < ActiveRecord::Base
  belongs_to :project
  has_many :issues

  enum status: %w(not_started adding_issues in_review voting voted_review complete)

  validates :creator_id, presence: true
  validates :meeting_date, presence: true, uniqueness: true
  validates :project_id, presence: true
  validates_inclusion_of :status, in: Retro.statuses.keys
end
