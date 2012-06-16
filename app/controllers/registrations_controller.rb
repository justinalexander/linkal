class RegistrationsController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      case resource.class.name
      when 'User'
        follow_organizations_url(:protocol => :http)
      else
        super
      end
    end
end
