# spec/support/features/session_helpers.rb
module SessionHelpers
  def sign_up_with(email, name, password)
    visit signup_path
    fill_in 'Email', with: email
    fill_in 'Name', with: name
    fill_in 'Password', with: password
    fill_in 'Confirm password', with: password
    click_button 'Submit'
  end

  def sign_in
    user = FactoryGirl.create(:user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def create_project_and_retro
    sign_in
    project = FactoryGirl.create(:project)
    visit project_path(project)
    retro = FactoryGirl.create(:retro)
    visit retro_path(retro)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers
end