class EventUpdates < ActionMailer::Base
  default :from => "events@senkd.com"
  def weekly_email(user)
    if user.weekly_email == true
      two_weeks_from_now = Time.now + (2*7*24*60*60)
      @events = Event.upcoming.from_organizations_followed_by(user).where('start_at < ?', two_weeks_from_now)
      mail(:to => user.email, :subject => 'Upcoming events')
    end
  end
end
