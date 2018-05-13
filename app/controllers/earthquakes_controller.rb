class EarthquakesController < ApplicationController
  def index
    redirect_to california_earthquakes_path
  end

  def california_earthquakes
    @title = "List all earthquakes in California in the past month, sorted by decreasing magnitude"
    @earthquakes = Earthquake.in('CA').sorted

    render :index
  end

  def top_us_cities_earthquakes
    @title = "List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude"
    @earthquakes = Earthquake.top_us_cities

    render :index
  end
end
