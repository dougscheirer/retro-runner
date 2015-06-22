class Project < ActiveRecord::Base
  has_many :retros

  validates :owner_id, presence: true
  #validates :description, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
