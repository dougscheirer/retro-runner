# test signing up
require 'rails_helper'

feature 'User signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'valid', 'password'

    expect(page).to have_content('Log out')
  end

  scenario 'with already created user' do
    sign_in

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

end