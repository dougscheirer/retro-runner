require 'rails_helper'

RSpec.describe "projects/index.html.erb", :type => :view do
  it "should list all the projects" do
    @projects = [ FactoryGirl.create(:project), FactoryGirl.create(:project) ]
    @users = [ FactoryGirl.create(:user) ]

    render

    @projects.each { |project|
      expect(rendered).to match /#{CGI.escapeHTML(project.name)}/
      expect(rendered).to match /#{project.description}/
      expect(rendered).to match /#{project.id}/
      expect(rendered).to match /#{CGI.escapeHTML(@users[0].name)}/
    }
    expect(rendered).to have_link('New Project', href: new_project_path)
  end

end
