ActiveAdmin.register Venue do
  
  form do |f|
    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :category
      f.input :email
    end
    f.inputs "Locations" do
      f.input :location
      f.input :billing_location
    end
    f.buttons
  end
  
end
