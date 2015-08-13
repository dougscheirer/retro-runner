require 'rails_helper'

RSpec.describe "retros/index.html.erb", :type => :view do
  it 'should list the retros in a table' do
    @project = FactoryGirl.create(:project)
    @retros = [ FactoryGirl.create(:retro), FactoryGirl.create(:retro) ]
    assign(:retros, @retros)
    assign(:project, @project)

    render

    @retros.each { |retro|
      expect(rendered).to have_content(retro.meeting_date.strftime("%F"))
      expect(rendered).to have_content(retro.status)
      expect(rendered).to have_link("#{retro.meeting_date.strftime("%F")}", href: retro_path(retro))
    }

    expect(rendered).to have_link('New Retro', new_project_retro_path(@project))
    expect(rendered).to have_link('Projects list', projects_path)
  end
end
