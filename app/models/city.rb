class City < ActiveRecord::Base
  has_many :events, :dependent => :nullify
end
