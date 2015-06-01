require 'rails_helper'

RSpec.describe ActionsController, :type => :controller do

  describe "GET new" do
    it "returns http success" do
      pending
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end
