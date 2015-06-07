require 'rails_helper'

RSpec.describe "projects/new.html.erb", :type => :view do
  it 'displays project details correctly' do
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)
    assign(:project, @project)
    assign(:users, [ @user ])

    render

    expect(rendered).to match /Create project/
    expect(rendered).to match /#{CGI.escapeHTML(@user.name)}/
    expect(rendered).to match /#{@user.email}/

    expect(rendered).to have_link('Cancel', href: projects_path)
  end
end
