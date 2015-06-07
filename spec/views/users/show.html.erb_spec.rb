require 'rails_helper'

RSpec.describe "users/show.html.erb", :type => :view do
  it 'should show the user details and gravatar' do
    @user = FactoryGirl.create(:user)
    assign(:user, @user)

    render

    expect(rendered).to match(/#{CGI.escapeHTML(@user.name)}/)
    expect(rendered).to match(/#{@user.email}/)
    expect(rendered).to have_link('Edit',href: edit_user_path(@user))
    expect(rendered).to have_link('Back to user list',href: users_path)
  end
end
