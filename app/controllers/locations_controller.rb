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

    @location = begin
      if params[:commit] == 'Search'
        # Get country code of country using countries gem
        # If country is blank nil is returned by Country
        country_code = Country.find_country_by_name(params[:location][:country]).try(:alpha2)
        response = HTTParty.get(URL_BASE + "?q=#{params[:location][:city]},#{country_code}")
        # Create new location object if api request succeeded
        response["cod"] == 200 ? build_location(response) : nil
      else
        create_random_location
      end
    end
    # We assume the city was not found because we didn't particularly check for a response code of 404
    if @location.nil?
      flash[:danger] = "Sorry, my friend. I did my best but I couldn't find the city."
      redirect_to root_url
    elsif @location.save
      # Get last search results used in view
      @history = get_search_history
      render :index
    else
      flash.now[:danger] = "Seems like something went wrong while saving to our database. Please try again!"
      redirect_to root_url
    end
  end

  private

    def create_random_location
      # Create url for api call using random geographic coordinates
      api_call = URL_BASE + "?lat=#{Faker::Address::latitude}&lon=#{Faker::Address::longitude}"
      response = HTTParty.get(api_call)
      location = response["cod"] == 200 ? build_location(response) : nil
      location
    end
end
