namespace :i_quake do
  desc "List all earthquakes in California in the past month, sorted by decreasing magnitude"
  task list_california_earthquakes: :environment do
    analyzer = IquakeAnalyzer.new
    data = analyzer.list_california_earthquakes
    analyzer.print_formatted_list(data)
  end

  desc "List all earthquakes in the top 3 US states (by number of quakes), sorted by state then by decreasing magnitude"
  task list_top_us_cities_earthquakes: :environment do
    analyzer = IquakeAnalyzer.new
    data = analyzer.list_top_us_cities_earthquakes
    analyzer.print_formatted_list(data)
  end
end
