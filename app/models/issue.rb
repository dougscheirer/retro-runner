class Issue < ActiveRecord::Base
  belongs_to :retro
  has_many :votes
  has_many :outstandings, dependent: :destroy

  validates :creator_id, presence: true
  validates :retro_id, presence: true
  validates :description, presence: true, length:{ minimum:2 }
  validates :issue_type, presence: true

  def type_to_int
    types = {"Good" => 0, "Meh" => 1, "Bad" => 2}
    types[issue_type]
  end

end
