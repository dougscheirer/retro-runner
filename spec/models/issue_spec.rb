require 'rails_helper'

RSpec.describe Issue, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:issue)).to be_valid
  end

  it 'is invalid without a creator id' do
    expect(Issue.create({
      :retro_id=>1,
      :issue_type=>'Good',
      :description=>'This is a good item'}
    )).not_to be_valid
  end

  it 'is invalid without a description' do
    expect(Issue.create({
      :retro_id=>1,
      :issue_type=>'Good',
      :creator_id=>1}
    )).not_to be_valid
  end

  it 'is invalid without a retro id' do
    expect(Issue.create({
      :description=>"This is a good item",
      :issue_type=>'Good',
      :creator_id=>1}
    )).not_to be_valid
  end

  it 'is invalid without a type' do
    expect(Issue.create({
      :description=>"This is a good item",
      :retro_id=>1,
      :creator_id=>1}
    )).not_to be_valid
  end
end
