require 'rails_helper'

RSpec.describe UsgsClient, type: :model do
  let(:client) { UsgsClient.new }
  let(:response) do
      path = Rails.root.join('spec/support/usgs_fake_response.json')
      file = File.open(path, "r")
      response = file.read
      file.close

      response
    end

  let(:json_response) { JSON.parse(response) }

  subject { client }

  describe '#initialize' do
    it 'should set api_uri' do
      expect(subject.api_uri).to eql('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    end
  end

  describe '#fetch_data' do
    let(:uri) { URI(client.api_uri) }
    subject { client.fetch_data }

    before(:each ) do
      allow(Net::HTTP).to receive(:get).and_return response
    end

    it 'should do http get request' do
      expect(Net::HTTP).to receive(:get).with(uri)
      subject
    end

    it 'should parse response into JSON' do
      subject
      expect(client.json).to eql(json_response)
    end
  end

  describe UsgsClient::DataParser do
    let(:parser) { UsgsClient::DataParser.new(json_response) }
    let(:features_count) { json_response['features'].count }
    let(:feature) { json_response['features'][0] }

    describe '#process_data' do
      before(:each) do
        allow(parser).to receive(:process_feature).and_return true
      end

      subject { parser.process_data }

      it 'processes features from dataset' do
        expect(parser).to receive(:process_feature).exactly(features_count).times
        subject
      end
    end

    describe '#processes_feature' do
      subject { parser.process_feature(feature) }
      let(:properties) { feature['properties'] }

      it 'should return id' do
        expect(subject).to include(id: feature['id'])
      end

      it 'should return place' do
        expect(subject).to include(place: properties['place'])
      end

      it 'should return time' do
        expect(subject).to include(time: properties['time'])
      end

      it 'should return tz' do
        expect(subject).to include(tz: properties['tz'])
      end

      it 'should return state' do
        place = properties['place']
        expect(parser).to receive(:get_state_from_place).with(place).and_return 'CA'
        expect(subject).to include(state: 'CA')
      end
    end

    describe '#get_state_from_place' do
      let(:place) { feature['properties']['place'] } # "15km SW of Leilani Estates, Hawaii"
      subject { parser.get_state_from_place(place) }

      it { is_expected.to eql('Hawaii') }

      it 'should get the state' do
        state = parser.get_state_from_place("15km SW of Leilani Estates, Hawaii")
        expect(state).to eql('Hawaii')

        state = parser.get_state_from_place("9km NE of Aguanga, CA")
        expect(state).to eql('CA')

        state = parser.get_state_from_place("90km NW of Talkeetna, Alaska")
        expect(state).to eql('Alaska')
      end
    end

  end
end
