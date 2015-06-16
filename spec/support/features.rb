module SessionHelpers
  def sign_up_with(email, name, password)
    visit signup_path
    fill_in 'Email', with: email
    fill_in 'Name', with: name
    fill_in 'Password', with: password
    fill_in 'Confirm password', with: password
    click_button 'Submit'
  end
end

RSpec.configure do |config|
  config.include SessionHelpers
end