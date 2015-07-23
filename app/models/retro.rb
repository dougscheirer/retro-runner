class Retro < ActiveRecord::Base
  belongs_to :project
  has_many :issues, dependent: :destroy

  enum status: %w(not_started review_last_retro adding_issues in_review voting voted_review complete restart)

  validates :creator_id, presence: true
  validates :meeting_date, presence: true, uniqueness: true
  validates :project_id, presence: true
  validates_inclusion_of :status, in: Retro.statuses.keys

  def int_to_type
    types =['Good', 'Meh', 'Bad']
    types[discussed_type]
  end


end
