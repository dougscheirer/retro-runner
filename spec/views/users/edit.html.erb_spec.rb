require 'rails_helper'

RSpec.describe "users/edit.html.erb", :type => :view do
  it 'should render the edit form' do
    @user = FactoryGirl.create(:user)

    render

    expect(rendered).to match(/#{CGI.escapeHTML(@user.name)}/)
    expect(rendered).to match(/#{@user.email}/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Confirm password/)
  end
end
