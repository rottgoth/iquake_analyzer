class IquakeAnalyzer

  def initialize
  end

  def list_california_earthquakes
    Earthquake.in('CA').sorted
  end

  def list_top_us_cities_earthquakes
    cities = Earthquake.select("*, COUNT(city)")
                       .group('city')
                       .order("count(city) desc")
                       .limit(3)
                       .pluck(:city)

    cities.reduce([]) do |acc, current_city|
      acc.concat(Earthquake.in(current_city).sorted)
    end
  end

  def print_formatted_list(list)
    puts list.map { |item| format_earthquake_record(item) }
  end

  def format_earthquake_record(record)
    date = record.happened_at.strftime("%Y-%m-%dT%H:%M:%S%:z")

    place = record.place.gsub('CA', 'California')

    mag = "Magnitude: #{record.magnitude}"

    [date, place, mag].join("\t|\t")
  end

  private
  def data_by_city
    @data_by_city ||= data.group_by { |earthquake| earthquake[:city] }
  end

  def sort_earthquakes(list = [])
    list.sort { |a, b| b[:mag] <=> a[:mag] }
  end
end