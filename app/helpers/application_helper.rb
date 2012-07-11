module ApplicationHelper
  # Always default to non-secure routes
  def url_for(options = nil)
    if Hash === options
      options[:protocol] ||= 'http'
    end
    super(options)
  end

  def events_url
    if session["events_url"].nil?
      my_events_url
    else
      session["events_url"]
    end
  end
  def link_to_pivotal(link_text, story_number, attributes = {}, &block)
    default_attributes = {
      :confirm => "Not yet implemented. Click OK to view Pivotal story or Cancel to stay on this page." }
    link_to( link_text,
             "https://www.pivotaltracker.com/story/show/#{story_number}",
             default_attributes.merge(attributes),
             &block )
  end

  # Returns the correct layout container class.
  def layout_container_class
    if params[:controller] == "events" && params[:action] == "show"
      "event container"
    else
      "container"
    end
  end
  
  # Returns true if we're on the very first welcome step1.
  def on_welcome_step_1?
    params[:controller] == "welcome" && params[:action] == "step_1"
  end
  
  # Returns options for selecting Cities, including the default "All Locations"
  def options_for_select_for_cities
    options_for_select(City.all.collect {|c| [c.name, c.id]} << ["All Locations", "0"])
  end

  def google_analytics
    analytics_code = <<-END
      <script type="text/javascript">
      
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', '#{Rails.env == 'production' ? 'UA-33312959-1' : 'UA-33312959-1'}']);
      _gaq.push(['_trackPageview']);
      
      (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
      
      </script>
      END
    analytics_code.html_safe
  end

  def current_city
    session[:city_id].to_i.zero? ? "All Locations" : session[:city_name]
  end

  def options_for_state_select
    US_STATES.map{ |s| [ s[:name], s[:abbr] ] } +
    CANADIAN_PROVINCES.map{ |s| [ s[:name], s[:abbr] ] }
  end

  def credit_card_types
    Venue::CARD_TYPES.collect { |card_type, company_name| [company_name, card_type] }
  end

  #static html_safe html snippet copied from Facebook's code generator
  def facebook_like
    "<iframe src=\"//www.facebook.com/plugins/like.php?href=#{CGI::escape(request.url)}&amp;send=false&amp;layout=button_count&amp;width=127&amp;show_faces=false&amp;action=recommend&amp;colorscheme=light&amp;font&amp;height=21&amp;appId=182622095550\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:127px; height:21px;\" allowTransparency=\"true\"></iframe>".html_safe
  end
  
  def twitter_link_tag(event)
    link_to image_tag('share.twitter.png'), "http://twitter.com/home?status=#{event.name} #{event_url(event)}", :target => "_blank"
  end
  
  def share_by_email_tag(event)
    mail_to nil, image_tag('share.email.png'), :subject => "Check out \"#{event.name}\" on SociaLatitude", :body => "#{event.name}\n\n#{event_url(event)}", :encode => "javascript"
  end

end
