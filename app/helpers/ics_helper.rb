module IcsHelper
  require 'icalendar'
  include Icalendar
  
  def render_ics(event, for_outlook = false)
    cal = Calendar.new
  
    ics_event = Event.new
    ics_event.dtstart localize(event.start_at.utc, :format => :ics), {:TZID => "US-Eastern" }
    ics_event.dtend localize(event.end_at ? event.end_at.utc : (event.start_at + 2.hours).utc, :format => :ics), { :TZID => "US-Eastern" }
    ics_event.summary = event.name
  
    ics_event.location = event.location.to_s  
    ics_event.url = event_url(event)
    ics_event.description = event.description
    
    cal.add_event(ics_event)
    cal_out = cal.to_ical
    cal_out = cal_out.gsub('VERSION:2.0', '') if for_outlook
    cal_out.html_safe
  end
end