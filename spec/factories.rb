FactoryGirl.define do
  factory :event do
    sequence(:name) {|n| "Event #{n}" }
    start_at { 1.hour.from_now }

    category 'visual-performing-arts'
    cost 0
    description { |ee|  "Description for #{ee.name}" }

    association :venue
  end

  factory :venue do
    sequence(:email) {|n| "test-#{n}@example.com" }
    password 'password'
    first_name 'Bob'
    last_name 'Smith'
    category 'corporation'

    association :location
    association :billing_location, :factory => :location

    # Note: the "test" credit card skips validations and calls to the
    # gateway. If you want to test gateway calls (or mocked/stubbed calls)
    # set it to a valid type (like visa, amex, etc.)
    credit_card_type 'test'
    credit_card_number '4111111111111111'
    credit_card_expires_on { 2.years.from_now.to_date }
    credit_card_verification_value '123'
  end

  factory :location do
    sequence(:name) {|n| "Restaurant #{n}"}
    phone '404-555-1212'
    address_1 '123 Main St.'
    city 'Atlanta'
    state 'GA'
    zip '30083'
    country 'US'
  end

  factory :city do
    name Forgery::Address.city
  end

  factory :view do
    ip_address Forgery::Internet.ip_v4
  end

end
