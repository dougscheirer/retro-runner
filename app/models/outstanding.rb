class Outstanding < ActiveRecord::Base
  belongs_to :issue
  has_and_belongs_to_many :users
  validates :description, presence: true, length:{minimum:2}
  validates :retro_id, presence: true
  validates :issue_id, presence: true
  #validates_presence_of :users

end