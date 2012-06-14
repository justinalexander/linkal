class Location < ActiveRecord::Base
  validates_presence_of :name, :phone, :address_1, :city, :country

  def to_s
    (self.address_1.blank? ? "" : "#{self.address_1}, " ) +
    (self.address_2.blank? ? "" : "#{self.address_2}, ") +
    (self.city.blank? ?  "" : "#{self.city}, " ) +
    (self.state.blank? ? "" : self.state )
  end

  def to_gmap_param
    (self.address_1.blank? ? "" : "#{self.address_1.gsub(' ', '+')}, " ) +
    (self.address_2.blank? ? "" : "#{self.address_2.gsub(' ', '+')}, ") +
    (self.city.blank? ?  "" : "#{self.city.gsub(' ', '+')}, " ) +
    (self.state.blank? ? "" : self.state.gsub(' ', '+') )
  end
end
