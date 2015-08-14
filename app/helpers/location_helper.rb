module LocationHelper

  # We use this as kind of a factory method in order to hide the details
  # of the data structure when creating the Location object
  def build_location(attr={})
    Location.new(
        city: attr["name"],
        country: Country[attr["sys"]["country"]],
        latitude: attr["coord"]["lat"],
        longitude: attr["coord"]["lon"],
        description: attr["weather"].first["description"],
        temp: attr["main"]["temp"],
        humidity: attr["main"]["humidity"],
        wind_speed: attr["wind"]["speed"]
        )
  end

  def get_search_history(limit=5)
    Location.order('created_at DESC').limit(limit)
  end
end
