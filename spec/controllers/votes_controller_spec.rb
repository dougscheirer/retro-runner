require 'rails_helper'

RSpec.describe VotesController, :type => :controller do

  let(:valid_session) { { 'user_id' => 1 } }

  # This should return the minimal set of attributes required to create a valid
  # Issues. As you add validations to Issues, be sure to
  # adjust the attributes here as well.
  before :each do
    @project = FactoryGirl.create(:project)
    @project.save
    @retro = FactoryGirl.create(:retro)
    @retro.save
    @user = FactoryGirl.create(:user)
    @user.save
    @issue = FactoryGirl.create(:issue)
    @issue.save
  end

  let(:valid_session) { { :user_id => 1 } }

  describe "GET new" do
    it "returns http success" do
      get :new, { :issue_id => 1 }, valid_session
      expect(response).to have_http_status(:success)
    end
  end

end
