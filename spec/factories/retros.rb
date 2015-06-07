FactoryGirl.define do
  factory :retro do
    meeting_date { Faker::Date.between(1_000_000.days.ago, Date.today) }
    project_id 1
    status "New"
    creator_id 1
  end
end
