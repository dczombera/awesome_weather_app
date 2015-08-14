class Location < ActiveRecord::Base
  store_accessor :weather, :description, :temp, :humidity, :wind_speed

  validates_presence_of :latitude, :longitude

end
