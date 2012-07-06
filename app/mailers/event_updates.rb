class EventUpdates < ActionMailer::Base
  default :from => "events@senkd.com"
  def weekly_email(user)
    @events = Event.upcoming.from_organizations_followed_by(user)
    mail(:to => user.email, :subject => 'Upcoming events')
  end
end
