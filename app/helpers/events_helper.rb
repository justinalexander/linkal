module EventsHelper
  
  def google_map_for_event(event)
    image_tag "http://maps.googleapis.com/maps/api/staticmap?center=#{event.location_id? ? event.location.to_gmap_param : event.venue.location.to_gmap_param}&zoom=14&size=298x232&maptype=roadmap&sensor=false&markers=color:blue%7C#{event.location_id? ? event.location.to_gmap_param : event.venue.location.to_gmap_param}"                    
  end

  def per_page_options
    options_for_select( [10, 20, 50, 100], :selected => params[:per_page] || Event.per_page )
  end

  def display_date(event)
    if event.end_at.present? && event.start_at.to_date != event.end_at.to_date
      "#{l(event.start_at, :format => :date_with_day)} - #{l(event.end_at, :format => :date_with_day)}" 
    else
      l(event.start_at, :format => :date_with_day)
    end
  end

  def date_range_header
    if @date.present?
      @date.to_s(:date)
    elsif @from.present? and @to.present?
      "#{@from.to_s(:date)} - #{@to.to_s(:date)}"
    end
  end

  def search_select(name, options)
    select_tag name,
      options_for_select(
        [["Any #{name.to_s.capitalize}", nil]] + options,
        :selected => params[name]),
      :class => "short half autosubmit_item"
  end

  def date_search_select(from, to)
    select_tag :date,
      options_for_select(
        [['All Dates', nil]] +
        (from.to_date..to.to_date).map{ |date| [ date.strftime('%A, %B, %e'), date.strftime('%m-%d-%Y') ] },
        :selected => params[:date]),
      :class => 'short half autosubmit_item'
  end

  def time_search_select(name)
    select_tag name,
      options_for_select(
        [['Any', nil]] + time_select_values,
        :selected => params[name]),
      :class => 'short small autosubmit_item'
  end

  def time_select_values
    [[ '12:00 AM', '0-00']] +
      (1..11).map{ |n| [ "#{n}:00 AM", "#{n}-00" ]} +
      [[ '12:00 PM', '12-00' ]] +
      (1..11).map{ |n| [ "#{n}:00 PM", "#{n + 12}-00" ]}
  end
end
