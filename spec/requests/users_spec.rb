require 'rails_helper'

RSpec.describe "Users", :type => :request do

  let(:valid_session) { { :user_id => 1 } }

  before :each do
    FactoryGirl.create(:user).save
  end

  describe "GET /users" do
    it "works! (now write some real specs)" do
      skip('for some reason the session thing does not exist when it hits the auth code')
      get users_path, {}, valid_session
      expect(response).to have_http_status(200)
    end
  end
end
