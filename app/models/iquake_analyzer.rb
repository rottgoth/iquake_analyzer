class IquakeAnalyzer

  attr_reader :data

  def initialize
    @data = UsgsClient.new.fetch_data
  end

  def list_california_earthquakes
    # alternative approach
    # data.group_by { |earthquake| earthquake[:city] }['CA']
    data.select { |earthquake| earthquake[:city] == 'CA' }
        .sort { |a, b| b[:mag] <=> a[:mag] }
  end

  def list_top_us_cities_earthquakes
    data.group_by { |earthquake| earthquake[:city] }
        .sort { |a, b| b.last.count <=> a.last.count }
        .take(3)
        .reduce([]) do |acc, current_city|
            city, earthquakes = current_city
            acc.concat earthquakes.sort { |a, b| b[:mag] <=> a[:mag] }
        end
  end
end