require 'rails_helper'

RSpec.describe "issues/index.html.erb", :type => :view do
  it 'should render the list of issues' do
    good = FactoryGirl.create(:issue);
    good.issue_type = 'Good'
    meh = FactoryGirl.create(:issue)
    meh.issue_type = 'Meh'
    bad = FactoryGirl.create(:issue)
    bad.issue_type = 'Bad'

    retro = FactoryGirl.create(:retro)
    project = FactoryGirl.create(:project)

    assign(:good_issues, [ good ])
    assign(:meh_issues, [ meh ])
    assign(:bad_issues, [ bad ])
    assign(:max_issues, 1)

    assign(:retro, retro)
    assign(:project, project)

    retro.status = 1
    render

    expect(rendered).to match(/#{good.description}/)
    expect(rendered).to match(/#{meh.description}/)
    expect(rendered).to match(/#{bad.description}/)
    expect(rendered).to have_link('New Issue', href: new_retro_issue_path(retro))
    expect(rendered).to have_link('All Retros', href: project_retros_path(project))
  end
end
