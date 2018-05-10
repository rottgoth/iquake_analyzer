require 'rails_helper'

RSpec.describe UsgsClient, type: :model do
  let(:client) { UsgsClient.new }
  subject { client }

  describe '#initialize' do
    it 'should set api_uri' do
      expect(subject.api_uri).to eql('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    end
  end

  describe '#fetch_data' do
    let(:response) do
      path = Rails.root.join('spec/support/usgs_fake_response.json')
      file = File.open(path, "r")
      response = file.read
      file.close

      response
    end

    let(:json_response) { JSON.parse(response) }
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
end
