# Authorize.net

# ==== How to Get Your API Login ID and Transaction Key
#
# 1. Log into the Merchant Interface
# 2. Select Settings from the Main Menu
# 3. Click on API Login ID and Transaction Key in the Security section
# 4. Type in the answer to the secret question configured on setup
# 5. Click Submit

# Authorize Log In ID – highgroove1
# Authorize password – HighGroove321

if Rails.env.production?
  # ActiveMerchant::Billing::Base.mode = :test  # live is default
  # Socialatitude Production Account
  ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
    :login => "2TG23tufc",
    :password => "66Zh5cA3ry3M657H"
  )
else
  ActiveMerchant::Billing::Base.mode = :test
  # Highgroove Developer Account
  ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
    :login => "7X7bPeR73y6",
    :password => "22khB9a6c2cCDR84",
    :test => true
  )
end
