require 'rails_helper'

RSpec.describe OutstandingsController, :type => :controller do

  let(:valid_attributes) {
    {
        :assigned_to => 'dscheirer@perforce.com',
        :retro_id => 1,
        :description => 'Nice job',
        :issue_id => 1
    }
  }

  let(:invalid_attributes) {
    { :pizza => "pepperoni" }
  }

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

  describe "GET new" do
    it "returns http success" do
      get :new, { :issue_id => 1 }, valid_session
      expect(response).to have_http_status(:success)
    end
  end

  context 'login is required' do
    describe "GET new" do
      it "assigns a new task as @outstanding" do
        get :new, { :issue_id => 1 }, valid_session
        expect(assigns(:outstanding)).to be_a_new(Outstanding)
      end
    end

    describe "GET edit" do
      it "assigns the requested task as @outstanding" do
        task = Outstanding.create! valid_attributes
        get :edit, {:id => task.to_param}, valid_session
        expect(assigns(:outstanding)).to eq(task)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Outstanding" do
          expect {
            post :create, {:outstanding => valid_attributes, :issue_id => 1}, valid_session
          }.to change(Outstanding, :count).by(1)
        end

        it "assigns a newly created task as @outstanding" do
          post :create, {:outstanding => valid_attributes, :issue_id => 1}, valid_session
          expect(assigns(:outstanding)).to be_a(Outstanding)
          expect(assigns(:outstanding)).to be_persisted
        end

        it "redirects to the created outstanding" do
          post :create, {:outstanding => valid_attributes, :issue_id => 1}, valid_session
          expect(response).to redirect_to(Retro.find(1))
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved task as @outstanding" do
        post :create, {:outstanding => invalid_attributes, :issue_id => 1}, valid_session
        expect(assigns(:outstanding)).to be_a_new(Outstanding)
      end

      it "re-renders the 'new' template" do
        post :create, {:outstanding => invalid_attributes, :issue_id => 1}, valid_session
        expect(response).to redirect_to(Retro.find(1))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {
            :assigned_to => "Phil@perforce.com",
            :issue_id => 1,
            :description => "Terrible job",
            :retro_id => 1
        }
      }

      it "updates the requested task" do
        task = Outstanding.create! valid_attributes
        put :update, {:id => task.to_param, :outstanding => new_attributes, :issue_id => 1}, valid_session
        task.reload
        new_attributes.each { |key, value|
          expect(task[key]).to eq(value)
        }
      end

      it "assigns the requested task as @outstanding" do
        outstanding = Outstanding.create! valid_attributes
        put :update, {:id => outstanding.to_param, :outstanding => valid_attributes, :issue_id => 1}, valid_session
        expect(assigns(:outstanding)).to eq(outstanding)
      end

      it "redirects to the outstanding" do
        outstanding = Outstanding.create! valid_attributes
        put :update, {:id => outstanding.to_param, :outstanding => valid_attributes, :issue_id => 1}, valid_session
        expect(response).to redirect_to(Retro.find(1))
      end
    end

    describe "with invalid params" do
      it "assigns the outstanding as @outstanding" do
        outstanding = Outstanding.create! valid_attributes
        put :update, {:id => outstanding.to_param, :outstanding => invalid_attributes, :issue_id => 1}, valid_session
        expect(assigns(:outstanding)).to eq(outstanding)
      end

      it "re-renders the 'edit' template" do
        outstanding = Outstanding.create! valid_attributes
        put :update, {:id => outstanding.to_param, :outstanding => invalid_attributes, :issue_id => 1}, valid_session
        expect(response).to redirect_to(Retro.find(1))
      end
    end
  end


end
