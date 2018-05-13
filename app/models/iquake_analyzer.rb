class IquakeAnalyzer

  def initialize
  end

  def list_california_earthquakes
    Earthquake.in('CA').sorted
  end

  def list_top_us_cities_earthquakes
    Earthquake.top_us_cities
  end

  def print_formatted_list(list)
    puts list.map { |item| format_earthquake_record(item) }
  end

  def format_earthquake_record(earthquake)
    [
      earthquake.formatted_happened_at,
      earthquake.place.gsub('CA', 'California'),
      "Magnitude: #{earthquake.magnitude}",
    ].join("\t|\t")
  end
end