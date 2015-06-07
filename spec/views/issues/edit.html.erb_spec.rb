require 'rails_helper'

RSpec.describe "issues/edit.html.erb", :type => :view do
  it 'should show the edit form' do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    issue = FactoryGirl.create(:issue)
    retro =  FactoryGirl.create(:retro)

    assign(:user, user)
    assign(:project, project)
    assign(:retro, retro)
    assign(:issue, issue)

    render

    expect(rendered).to match(/#{issue.issue_type}/)
    expect(rendered).to match(/#{issue.description}/)
    expect(rendered).to match(/Modify/)
    expect(rendered).to have_link('Cancel', href: retro_issues_path(issue))
  end
end
