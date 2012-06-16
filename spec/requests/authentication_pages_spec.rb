require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit new_user_session_path  }

    it { should have_selector('h3', text: 'Log In') }
  end

  describe "signin" do
    before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Log In" }

      it { should have_selector('h3', text: 'Log In') }
      it { should have_error_message }

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('h2', text: "My Events") }
      it { should have_link('Settings', href: follow_organizations_path) }

      describe "followed by signout" do
        before do
          click_link "Settings"
          click_link "Log Out"
        end
        it { should have_button("Log In") }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit follow_organizations_path
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log In"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('h2', text: 'Account Settings')
          end

          describe "when signing in again" do
            before do
              click_link "Log Out"
              click_button "Log In"
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Log In"
            end

            it "should render the default (my events) page" do
              page.should have_selector('h2', text: "My Events")
            end
          end
        end
      end

    end
  end
end
