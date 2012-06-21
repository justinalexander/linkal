module MainHelper
  def events_as_json(events)
    events.collect do |event|
      {
        :id => event.id,
        :day => event.start_at.day
      }
    end.to_json
  end
  def format_date(date)
    if date.nil?
      return ''
    end
    date.strftime("%A %B #{date.day.ordinalize}")
  end
end

