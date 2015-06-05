require 'rails_helper'

RSpec.describe "Users", :type => :request do

  let(:valid_session) { { 'user_id' => 1 } }

  describe "GET /users" do
    it "works! (now write some real specs)" do
      get users_path, {}, valid_session
      expect(response).to have_http_status(200)
    end
  end
end
