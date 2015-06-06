require 'rails_helper'

RSpec.describe "projects/edit.html.erb", :type => :view do
  it 'displays project details correctly' do
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)
    assign(:project, @project)
    assign(:users, [ @user ])

    render

    expect(rendered).to match /#{@project.name}/
    expect(rendered).to match /#{@project.description}/
    expect(rendered).to match /#{@user.name}/
  end
end
