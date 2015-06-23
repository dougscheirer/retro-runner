class Vote < ActiveRecord::Base
  belongs_to :issue
  validates :member_id, presence: true
  validates :issue_id, presence: true
end