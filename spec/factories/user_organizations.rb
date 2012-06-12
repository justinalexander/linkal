# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_organization do
    user_id 1
    venue_id 1
    follow_company_event true
    follow_endorsed_events true
  end
end
