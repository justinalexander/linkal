# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test-#{n}@example.com" }
    password 'password'
    first_name 'Bob'
    last_name 'Smith'
    remember_token 'token'
  end
end
