Factory.define :event do |e|
  e.sequence(:name) {|n| "Event #{n}" }
  e.start_at { 1.hour.from_now }
  
  e.category 'visual-performing-arts'
  e.cost 0
  e.description { |ee|  "Description for #{ee.name}" }

  e.association :venue
end

Factory.define :venue do |v|
  v.sequence(:email) {|n| "test-#{n}@example.com" }
  v.password 'password'
  v.first_name 'Bob'
  v.last_name 'Smith'
  v.category 'corporation'
  
  v.association :location
  v.association :billing_location, :factory => :location
  
  # Note: the "test" credit card skips validations and calls to the
  # gateway. If you want to test gateway calls (or mocked/stubbed calls)
  # set it to a valid type (like visa, amex, etc.)
  v.credit_card_type 'test'
  v.credit_card_number '4111111111111111'
  v.credit_card_expires_on { 2.years.from_now.to_date }
  v.credit_card_verification_value '123'
end

Factory.define(:location) do |l|
  l.sequence(:name) {|n| "Restaurant #{n}"}
  l.phone '404-555-1212'
  l.address_1 '123 Main St.'
  l.city 'Atlanta'
  l.state 'GA'
  l.zip '30083'
  l.country 'US'
end

Factory.define :city do |c|
  c.name Forgery(:address).city
end

Factory.define :view do |v|
  v.ip_address Forgery(:internet).ip_v4
end

