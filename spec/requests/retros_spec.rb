require 'rails_helper'

RSpec.describe "Retros", :type => :request do

  before(:each) do
    FactoryGirl.create(:project).save
  end

  describe "GET /retros" do
    it "works! (now write some real specs)" do
      get project_retros_path(1)
      expect(response).to have_http_status(200)
    end
  end
end
