class RegistrationsController < Devise::RegistrationsController
  protected
    def after_sign_up_path_for(resource)
      follow_organizations_url(:protocol => 'http')
    end
    def after_inactive_sign_up_path_for(resource)
      follow_organizations_url(:protocol => 'http')
    end
end
