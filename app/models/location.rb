class Location < ActiveRecord::Base
  store_accesor :weather,

  validates_presence_of :city, :country, :latitude, :longitude

end
