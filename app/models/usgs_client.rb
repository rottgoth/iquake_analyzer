class UsgsClient

  attr_reader :api_uri
  attr_accessor :json

  def initialize
    @api_uri = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
  end

  def fetch_data
    # get data from remote api
    response = Net::HTTP.get(URI(api_uri))
    # parse response
    self.json = JSON.parse(response)
  end
end