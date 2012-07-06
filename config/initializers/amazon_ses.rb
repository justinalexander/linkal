ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => AMAZON_ACCESS_KEY,
  :secret_access_key => AMAZON_SECRET_KEY
