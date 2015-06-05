require 'rails_helper'

RSpec.describe "Issue", :type => :request do

  before(:each) do
    FactoryGirl.create(:project).save
    FactoryGirl.create(:retro).save
  end

  describe "GET /issues" do
    it "works! (now write some real specs)" do
      get retro_issues_path(1)
      expect(response).to have_http_status(200)
    end
  end
end
