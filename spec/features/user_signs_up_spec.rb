# test signing up
require 'rails_helper'

feature 'User signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'valid', 'password'

    expect(page).to have_content('Log out')
  end

  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'valid', 'password'

    expect(page).to have_content('Log in')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', 'valid', ''

    expect(page).to have_content('Log in')
  end

  scenario 'with blank name' do
    sign_up_with 'valid@example.com', '', 'password'

    expect(page).to have_content('Log in')
  end

  def sign_up_with(email, name, password)
    visit signup_path
    fill_in 'Email', with: email
    fill_in 'Name', with: name
    fill_in 'Password', with: password
    fill_in 'Confirm password', with: password
    click_button 'Submit'
  end
end