class Retro < ActiveRecord::Base
  belongs_to :project
  has_many :issues

  validates :creator_id, presence: true
  validates :meeting_date, presence: true, uniqueness: true
  validates :project_id, presence: true
  validates :status, presence: true

  enum status: %w(not_started adding_issues in_review voting voted_review complete)
end
