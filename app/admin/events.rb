ActiveAdmin.register Event do
  form do |f|
    f.semantic_errors
    f.inputs "Event" do
      f.input :name
      f.input :venue
      f.input :category, :collection => Event.categories_for_select
      f.input :city
      f.input :other_category_name
      f.input :cost
      f.input :start_at
      f.input :end_at
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
      link_to event.venue.location.name, admin_venue_path(event.venue)
    end
    column "Date" do |event|
      display_date(event)
    end
    column :category do |event|
      event.category_name
    end
    column :cost do |event|
      number_to_currency event.cost
    end
    column :attending
    column :maybe_attending
    column "Balance" do |event|
      number_to_currency event.balance
    end
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
      row :category
      row :city
      row :other_category_name
      row :cost do
        number_to_currency( event.cost ) 
      end
      row :start_at
      row :end_at
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
      row :balance do
        number_to_currency( event.balance )    
      end
    end
    active_admin_comments
  end
end