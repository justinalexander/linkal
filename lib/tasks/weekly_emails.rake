namespace :weekly_emails do
  desc "weekly emails to all subscribed users with list of events"
  task :event_updates => :environment do
    if Time.now.friday?
      puts 'Sending emails...'
      User.all.each do |user|
        if user.weekly_email?
          EventUpdates.weekly_email(user).deliver
        end
      end
      puts 'done.'
    end
  end

  task :all => [:event_updates]
end
