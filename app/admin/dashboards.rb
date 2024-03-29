ActiveAdmin::Dashboards.build do

     section "Recent Users" do
       table_for User.order("id desc").limit(5).each do 
         column :first_name
         column :last_sign_in_at
         column :sign_in_count
       end
       strong { link_to "View All Users", admin_users_path }
      end

      section "Recent Events" do
        table_for Event.order("start_at desc").limit(5).each do 
          column :name
          column :venue
        end
        strong { link_to "View All Events", admin_events_path }
        
      
       # strong { link_to 'New Event', admin_events_new_path }
     
       
       end
end
 



  
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.


