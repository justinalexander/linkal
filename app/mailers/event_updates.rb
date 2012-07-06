class EventUpdates < ActionMailer::Base
  default :from => "from@example.com"
  def weekly_email(user)
    mail(:to => user.email, :subject => 'Upcoming events')
  end
end
