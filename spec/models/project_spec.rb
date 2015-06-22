require 'rails_helper'

RSpec.describe Project, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end

  it 'is invalid without a owner_id' do
    expect(Project.create({
      :description=>"this is a project",
      :name=>"project name"
    })).not_to be_valid
  end

  it 'is valid without a description' do
    expect(Project.create({
      :owner_id=>1,
      :name=>"project name"
    })).to be_valid
  end

  it 'is invalid without a name' do
    expect(Project.create({
      :description=>"this is a project",
      :owner_id=>1
    })).not_to be_valid
  end

  it 'is invalid if a duplicate exists' do
    Project.create({:description=>"this is a project",
                    :owner_id=>1,
                    :name=>'project name'})
    expect(Project.create({:description=>"this is the same project",
                     :owner_id=>1,
                     :name=>'Project Name'})).not_to be_valid
  end
end
