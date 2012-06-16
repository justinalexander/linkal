include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert', text: 'Invalid')
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
