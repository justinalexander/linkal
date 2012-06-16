include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div#error_explanation', text: '')
  end
end

def sign_in(user)
  visit new_user_session_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log In"
  # Sign in when not using Capybara.
  cookies[:remember_token] = user.remember_token
end

def sign_up(user)
  visit new_user_registration_path
  fill_in "First name", with: user.first_name
  fill_in "Last name", with: user.last_name
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  fill_in "Password confirmation", with: user.password
  click_button "Sign Up"
end
