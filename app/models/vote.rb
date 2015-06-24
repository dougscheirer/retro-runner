class Vote < ActiveRecord::Base
  belongs_to :issue
  validates :user_id, presence: true
  validates :issue_id, presence: true
  validates :retro_id, presence: true
end