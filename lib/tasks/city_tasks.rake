desc "Rake tasks associated with this apps City model"
namespace :cities do
  desc "Sets up the apps default Cities and associates all events"
  task :set_defaults => :environment do
    City.transaction do
      City.find_or_create_by_name("Davidson")
      City.find_or_create_by_name("Cornelius")
    end
    Event.transaction do
      Event.unscoped.update_all(:city_id => City::DEFAULT_CITY_ID)
    end
  end
end