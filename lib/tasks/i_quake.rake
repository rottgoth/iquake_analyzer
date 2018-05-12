namespace :i_quake do
  desc "Download data from USGS api and inserts new record in the database"
  task fetch_latest_data: :environment do
    client = UsgsClient.new
    puts "- Fetching data..."
    client.fetch_data
    puts "- Data fetched"
    counter = 0
    print "- Inserting new records (may take a couple minutes)  "
    client.data.each do |attrs|
      print '.'
      next if Earthquake.exists? usgs_id: attrs[:usgs_id]
      counter += 1
      Earthquake.create(attrs)
    end

    puts "\n- New records inserted: #{counter}"
  end

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
