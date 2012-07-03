module MainHelper
  def events_as_json(events)
    days = Set.new
    events.each do |event|
      if event.end_at.nil?
        days.add event.start_at.day
      else
        days.merge (event.start_at.day .. [event.end_at, event.start_at.end_of_month].min.day)
      end
    end
    days.to_json
  end
  def format_date(date)
    if date.nil?
      return ''
    end
    date.strftime("%a %B #{date.day.ordinalize}")
  end
end
