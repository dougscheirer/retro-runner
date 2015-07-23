require 'rails_helper'

RSpec.describe Retro, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:retro)).to be_valid
  end

  it 'is invalid without a creator id' do
    expect(Retro.create({
      :meeting_date=>'2015/06/01',
      :project_id=>1,
      :status=>Retro.not_started
    })).not_to be_valid
  end

  it 'is invalid without a meeting date' do
    expect(Retro.create({
      :creator_id=>1,
      :project_id=>1,
      :status=>Retro.not_started
    })).not_to be_valid
  end

  it 'is invalid without a project id' do
    expect(Retro.create({
      :creator_id=>1,
      :meeting_date=>'2015/06/01',
      :status=>Retro.not_started
    })).not_to be_valid
  end

  #commented out because create now doesn't accept user-input statuses
  #it 'is invalid without a status' do
   # expect(Retro.create({
   #   :creator_id=>1,
   #   :meeting_date=>'2015/06/01',
   #   :project_id=>1,
   # })).not_to be_valid
  #end

  it 'is invalid if the meeting dates match' do
    Retro.create({   :creator_id=>1,
                            :meeting_date=>'2015/06/01',
                            :status=>Retro.not_started,
                            :project_id=>1
                        })
    expect(Retro.create({   :creator_id=>1,
                            :meeting_date=>'2015/06/01',
                            :status=>Retro.not_started,
                            :project_id=>1
                        })).not_to be_valid
  end
end
