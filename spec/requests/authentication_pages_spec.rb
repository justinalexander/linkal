require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit new_user_session_path  }

    it { should have_selector('h3', text: 'Log In') }
  end

  describe "signup page" do
    before { visit new_user_registration_path  }

    it { should have_selector('h3', text: 'Sign Up') }
  end

  describe "signin" do
    before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Log In" }

      it { should have_selector('h3', text: 'Log In') }
      it { should have_error_message }

    end

    describe "with valid information without following" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end
      it { should_not have_selector('h2', text: "My Events") }

    end
    describe "with valid information" do
      before do
        @org = FactoryGirl.create(:venue)
        @event = FactoryGirl.create(:event, venue_id: @org.id )

        @user = FactoryGirl.create(:user)
        @user.user_organizations.create(venue_id: @org.id)

        sign_in @user
      end
      it { should have_selector('h2', text: "My Events") }
      it { should have_link('Settings', href: settings_organizations_path) }

      describe "followed by signout" do
        before do
          click_link "Settings"
          click_link "Log Out"
        end
        it { should have_button("Log In") }
      end
    end
  end

  describe "signup" do
    before { visit new_user_registration_path }

    describe "with invalid information" do
      before { click_button "Sign Up" }

      it { should have_selector('h3', text: 'Sign Up') }
      it { should have_error_message }

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.build(:user) }
      before { sign_up user }

      it { should_not have_selector('h3', text: "Sign Up") }
      it { should_not have_selector('h2', text: "My Events") }
      it { should have_link('My Groups', href: settings_organizations_path)}
    end
  end


  describe "authorization" do

    describe "for non-signed-in users" do
      before do
        @org = FactoryGirl.create(:venue)
        @event = FactoryGirl.create(:event, venue_id: @org.id )

        @user = FactoryGirl.create(:user)
        @user.user_organizations.create(venue_id: @org.id)
      end

      describe "when attempting to visit a protected page" do
        before do
          visit settings_organizations_path
          fill_in "Email",    with: @user.email
          fill_in "Password", with: @user.password
          click_button "Log In"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_link('Edit groups', href: follow_organizations_path)
          end

          describe "when signing in again" do
            before do
              click_link "Log Out"
              click_button "Log In"
              fill_in "Email",    with: @user.email
              fill_in "Password", with: @user.password
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
