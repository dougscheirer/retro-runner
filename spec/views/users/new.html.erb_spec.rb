require 'rails_helper'

RSpec.describe "users/new.html.erb", :type => :view do
  it 'renders the sign up form' do
    assign(:user, FactoryGirl.create(:user))

    render

    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Confirm password/)
  end
end
