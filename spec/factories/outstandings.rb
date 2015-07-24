FactoryGirl.define do
  factory :outstanding, :class => 'Outstandings' do
    retro_id 1
    issue_id 1
    creator_id 1
    description 'This is a good item'
    assigned_to ["1"]
  end

end
