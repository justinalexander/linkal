module EventUpdatesHelper
  def display_date(event)
    if event.end_at.present? && event.start_at.to_date != event.end_at.to_date
      "#{l(event.start_at, :format => :date_with_day)} - #{l(event.end_at, :format => :date_with_day)}" 
    else
      l(event.start_at, :format => :date_with_day)
    end
  end
end
