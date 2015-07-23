require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:vote)).to be_valid
  end

  it 'is invalid without a user id' do
    expect(Vote.create({
                            :retro_id=>1,
                            :issue_id=>1, }
           )).not_to be_valid
  end

  it 'is invalid without an issue id' do
    expect(Vote.create({
                            :retro_id=>1,
                            :user_id=>1 }
           )).not_to be_valid
  end

  #commented out because without retro_id, it just finds one in the given issue
  #it 'is invalid without a retro id' do
    #expect(Issue.create({
    #                        :issue_id=>1,
    #                        :user_id=>1,
    #                        :retro_id=>nil  }
    #       )).not_to be_valid
  #end
end
