require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it 'is invalid without a name' do
    expect(User.create({    :email=>'test@example.com',
      :password=>'notsecure',
      :password_confirmation=>'notsecure'}
    )).not_to be_valid
  end

  it 'is invalid without an email' do
    expect(User.create({    :name=>'test',
                            :password=>'notsecure',
                            :password_confirmation=>'notsecure'}
           )).not_to be_valid
  end

  it 'is invalid without matching passwords' do
    expect(User.create({   :email=>'test@example.com',
                           :name=>'test',
                          :password=>"notsecure",
                          :password_confirmation=>''
                       }
           )).not_to be_valid
  end

end
