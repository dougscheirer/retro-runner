require 'rails_helper'

RSpec.describe "users/index.html.erb", :type => :view do
  it 'should render the list of users' do
    @users = [ FactoryGirl.create(:user), FactoryGirl.create(:user) ]
    @users[1].admin = true

    render

    @users.each { |user|
      expect(rendered).to match(/#{CGI.escapeHTML(user.name)}/)
      expect(rendered).to match(/#{user.email}/)
    }

    expect(rendered).to have_link('New User', href: new_user_path)
  end
end
