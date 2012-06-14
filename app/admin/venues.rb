ActiveAdmin.register Venue do
  form do |f|
    f.semantic_errors

    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
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
end
