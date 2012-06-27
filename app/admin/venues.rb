ActiveAdmin.register Venue do
  form do |f|
    f.semantic_errors

    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :organization_name
      f.input :category, :collection => Venue.categories_for_select
      f.input :email
    end
    f.inputs "Locations" do
      f.input :location
      f.input :billing_location
    end
    f.inputs "Password" do
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
  index do
    column :name do |venue|
      link_to venue.name, admin_venue_path(venue)
    end
    column :first_name do |v|
      v.first_name
    end
    column :last_name do |v|
      v.last_name
    end
    column :category do |v|
      v.category_name
    end
    column :created_at do |v|
      v.created_at
    end
    default_actions
  end

end
