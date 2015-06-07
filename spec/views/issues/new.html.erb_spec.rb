require 'rails_helper'

RSpec.describe "issues/new.html.erb", :type => :view do
  it 'should show the new issue template' do
    project = FactoryGirl.create(:project)
    retro = FactoryGirl.create(:retro)
    user = FactoryGirl.create(:user)
    issue = Issue.new

    assign(:project, project)
    assign(:retro, retro)
    assign(:user, user)
    assign(:issue, issue)

    render

    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Add item/)
    expect(rendered).to have_link('Back to the Retro', href: retro_issues_path(retro))
  end
end
