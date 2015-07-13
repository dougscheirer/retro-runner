require 'rails_helper'

RSpec.describe VotesController, :type => :controller do

  let(:valid_session) { { 'user_id' => 1 } }
  let(:valid_session_2) { { 'user_id' => 2} }

  let(:valid_attributes) {
    {
        :issue_id => 1,
        :retro_id => 1,
        :user_id => 1
    }
  }

  let(:valid_attributes_2) {
    {
        :issue_id => 1,
        :retro_id => 1,
        :user_id => 2
    }
  }

  let(:invalid_attributes) {
    { :pizza => "pepperoni" }
  }

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
    @user2 = FactoryGirl.create(:user)
    @user2.save
    @issue = FactoryGirl.create(:issue)
    @issue.save
  end


  describe "GET new" do
    it "returns http success" do
      get :new, { :issue_id => 1 }, valid_session
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new vote" do
        expect {
          post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        }.to change(Vote, :count).by(1)
      end

      it "assigns a newly created vote as @vote" do
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        expect(assigns(:vote)).to be_a(Vote)
        expect(assigns(:vote)).to be_persisted
      end

      it "redirects to the vote's issue" do
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        expect(response).to redirect_to(Retro.find(1))
      end

      it "fails if there are too many votes" do
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        expect(flash[:error]).to be_present
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved vote as @vote" do
        post :create, {:vote => invalid_attributes, :issue_id => 1}, valid_session
        expect(assigns(:vote)).to be_a(Vote)
        expect(assigns(:vote)).to be_persisted
      end

      it "redirects to the vote's issue" do
        post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
        expect(flash[:success]).to be_present
      end
    end
  end

  describe "GET clear_all" do
    it "deletes all votes belonging to the right user" do
      post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
      post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
      post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
      expect(Vote.count).to be(3)
      get :clear_all, valid_attributes
      expect(Vote.count).to be(0)
    end
    it "deletes only votes belonging to the right user" do
      expect(Vote.count).to be(0)
      post :create, {:vote => valid_attributes, :issue_id => 1}, valid_session
      post :create, {:vote => valid_attributes_2, :issue_id => 1}, valid_session_2
      expect(Vote.where(user_id: 2).count).to be(1)
      expect(Vote.count).to be(2)
      get :clear_all, valid_attributes
      expect(Vote.count).to be(1)
    end
  end

end
