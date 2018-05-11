class IquakeAnalyzer

  attr_reader :data

  def initialize
    @data = UsgsClient.new.fetch_data
  end

  def list_california_earthquakes
    sort_earthquakes data_by_city['CA']
  end

  def list_top_us_cities_earthquakes
    data_by_city
      .sort { |a, b| b.last.count <=> a.last.count } # sort cities by highest earthquakes count
      .take(3) # take the first 3 cities (this could be parameterized)
      .reduce([]) do |acc, current_city|
        # sort earthquakes by mag within each city anc join them in the same loop
        city, earthquakes = current_city
        acc.concat sort_earthquakes(earthquakes)
      end
  end

  private
  def data_by_city
    @data_by_city ||= data.group_by { |earthquake| earthquake[:city] }
  end

  def sort_earthquakes(list = [])
    list.sort { |a, b| b[:mag] <=> a[:mag] }
  end
end