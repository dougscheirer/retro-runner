require 'rails_helper'

RSpec.describe "retros/new.html.erb", :type => :view do
  it 'should show the new retro form' do
    @project = FactoryGirl.create(:project)
    assign(:project, @project)
    # controller.request.path_parameters[:project_id] = @project.id

    render

    expect(rendered).to have_field('today')
    expect(rendered).to have_button('submit')
    expect(rendered).to have_link('Cancel', href: project_retros_path(@project))
  end
end
