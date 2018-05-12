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
      city = get_city_from_place(attributes['place'])
      happened_at = get_utc_date_from_epoc_miliseconds(attributes['time'])

      return {
        usgs_id: id,
        magnitude: attributes['mag'],
        place: attributes['place'],
        city: city,
        happened_at: happened_at,
        timezone: attributes['tz'],
      }
    end

    def get_city_from_place(place)
      place.match(/,\s(.*)$/) { |m| m[1] }
    end

    def get_utc_date_from_epoc_miliseconds(time)
      Time.at(time / 1000.0).utc
    end
  end
end