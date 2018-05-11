class UsgsClient

  attr_reader :api_uri
  attr_accessor :data

  def initialize
    @api_uri = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson'
  end

  def fetch_data
    # get data from remote api
    response = Net::HTTP.get(URI(api_uri))
    # parse response
    parser = UsgsClient::DataParser.new(JSON.parse(response))
    self.data = parser.data
  end

  class DataParser
    # from https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php
    attr_accessor :data
    # information we need: id, mag, place, time, tz
    FEATURE_ATTRIBUTES = ['mag', 'place', 'time', 'tz']

    def initialize(json={})
      process_data(json)
    end

    def process_data(json)
      features = json['features'] || []
      self.data = features.map do |feature|
        process_feature(feature)
      end
    end

    def process_feature(feature = {})
      id = feature['id']
      attributes = feature['properties'].slice(*FEATURE_ATTRIBUTES)
      state = get_state_from_place(attributes['place'])
      return {
        id: id,
        mag: attributes['mag'],
        place: attributes['place'],
        state: state,
        time: attributes['time'],
        tz: attributes['tz'],
      }
    end

    def get_state_from_place(place)
      place.match(/,\s(.*)$/) { |m| m[1] }
    end
  end
end