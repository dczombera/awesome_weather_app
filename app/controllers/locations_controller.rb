class LocationsController < ApplicationController
  include LocationHelper

  # Constants
  URL_BASE = "http://api.openweathermap.org/data/2.5/weather"

  def index
  end

  def create
    if params[:commit] == 'Search' && params[:location][:city].blank?
      flash[:danger] = "You have to give me at least the name of a city if you want to know the weather, young padawan."
      redirect_to root_url
      return
    end

    unit = params["unit"]["value"]
    # Let's create the propery URL for the api call
    api_call = begin
      if params[:commit] == 'Search'
        country_code = Country.find_country_by_name(params[:location][:country]).try(:alpha2)
        URL_BASE + "?q=#{params[:location][:city]},#{country_code}&units=#{unit}"
      else
        URL_BASE + "?lat=#{Faker::Address::latitude}&lon=#{Faker::Address::longitude}&units=#{unit}"
      end
    end

    # Call Open Weather Map API
    response = HTTParty.get(api_call)

    if response["cod"] == 200
      response["unit"] = convert_to_unit_of_measurement(unit)
      @location = build_location(response)
    # Show flash message when city wasn't found. Api returns response code as string.
    elsif response["cod"] == "404"
      flash[:danger] = "Sorry, my friend. I did my best but I couldn't find the city."
      redirect_to root_url
      return
    else
      flash[:danger] = "Opps. Something went wrong. Please try again!"
      redirect_to root_url
      return
    end

    if @location.save
      # Get last search results used in view to show search history
      @history = get_search_history
      render :index
    else
      flash[:danger] = "Seems like something went wrong while saving to our database. Please try again!"
      redirect_to root_url
    end
  end
end
