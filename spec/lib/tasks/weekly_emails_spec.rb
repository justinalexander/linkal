require 'spec_helper'
require 'rake'

describe 'weekly emails rake task' do
  before :all do
    Rake.application.rake_require "tasks/weekly_emails"
    Rake::Task.define_task(:environment)
  end

  describe 'weekly_emails:event_updates' do
    before do
      @user = FactoryGirl.create(:user)
      @user.weekly_email = true
    end

    let :run_rake_task do
      Rake::Task["weekly_emails:event_updates"].reenable
      Rake.application.invoke_task "weekly_emails:event_updates"
    end

    it "should send one email" do
      run_rake_task
      ActionMailer::Base.deliveries.count.should eql 1
    end
  end
end
