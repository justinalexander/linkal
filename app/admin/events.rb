ActiveAdmin.register Event do
  form do |f|
    f.semantic_errors
    f.inputs "Event" do
      f.input :name
      f.input :venue
      f.input :category, :collection => Event.categories_for_select
      f.input :other_category_name
      f.input :industry, :collection => Event.industries_for_select
      f.input :business_relation, :as => :select, :collection => Event.relations_for_select
      f.input :city
      f.input :cost
      f.input :start_at, :as => :string,
        :wrapper_html => {:class => "datetimepicker"},
        :input_html => {:value => f.object.start_at.nil? ? '' : f.object.start_at.strftime('%F %R')}
      f.input :end_at, :as => :string,
        :wrapper_html => {:class => "datetimepicker"},
        :input_html => {:value => f.object.end_at.nil? ? '' :f.object.end_at.strftime('%F %R')}
      f.input :description
      f.input :location
    end
    f.buttons
  end

  index do
    column "Name" do |event|
      link_to event.name, admin_event_path(event) 
    end
    column :venue do |event|
      if event.venue.nil?
        event.location_name
      elsif event.venue.location.nil?
        event.location_name
      else
        link_to event.venue.location.name, admin_venue_path(event.venue)
      end
    end
    column "Date" do |event|
      display_date(event)
    end
    column :category do |event|
      event.category_name
    end
    column :industry do |event|
      event.industry_name
    end
    column :relation do |event|
      event.relation_name
    end
    column :attending
    column :maybe_attending
    column :not_attending
    column 'Page Clicks' do |event|
      number_to_human event.views.count
    end
    default_actions
  end

  #https://github.com/gregbell/active_admin/blob/master/docs/6-show-screens.md
  show do
    attributes_table do
      row :name
      row :venue
      row :category do
        event.category_name
      end
      row :industry do
        event.industry_name
      end
      row :relation do
        event.relation_name
      end
      row :city
      row :start_at do
        event.start_at.strftime('%F %R') if not event.start_at.nil?
      end
      row :end_at do
        event.end_at.strftime('%F %R') if not event.end_at.nil?
      end
      row :description do
        simple_format event.description
      end
      row :location
      row :page_clicks do
        event.views.count
      end
      row :unique_ip_addresses do
        table do
          tr do
            th "Date Clicked"
            th "IP Address"
            th 'Click Came From'
          end
          if event.views.empty?
            tr do
              td(:colspan => 3) { "No Clicks Yet" }
            end
          else
            event.views.each do |v|
              tr do
                td v.created_at.to_s :long
                td v.ip_address
                td v.http_referer.blank? ? 'Direct' : v.http_referer 
              end
            end
          end
        end
      end
      row :attending
      row :maybe_attending
      row :not_attending
    end
    active_admin_comments
  end

  controller do
    def update
      update! do |format|
        @event.start_at = Time.zone.parse(params[:event][:start_at]) if not params[:event][:start_at].nil?
        @event.end_at = Time.zone.parse(params[:event][:end_at]) if not params[:event][:end_at].nil?
        unless @event.errors.empty? # failure
          format.html { redirect_to admin_event_url(@event) }
        end
      end
    end
    def create
      create! do |format|
        @event = Event.new(params[:event])
        @event.start_at = Time.zone.parse(params[:event][:start_at]) if not params[:event][:start_at].nil?
        @event.end_at = Time.zone.parse(params[:event][:end_at]) if not params[:event][:end_at].nil?
        unless @event.errors.empty? # failure
          format.html { redirect_to admin_event_url(@event) }
        end
      end
    end
  end
end
