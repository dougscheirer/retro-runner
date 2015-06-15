# spec/support/features/session_helpers.rb
module Features
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
      user = create(:user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end