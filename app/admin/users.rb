ActiveAdmin.register User do
  index do
    column :email
    column :weekly_email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :weekly_email
    end
    f.buttons
  end
end
