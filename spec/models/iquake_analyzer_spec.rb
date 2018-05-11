require 'rails_helper'

RSpec.describe IquakeAnalyzer, type: :model do

  let(:analyzer) { IquakeAnalyzer.new }
  let(:data) { [] }
  let(:sorting_mags) do
    -> (records) { records.map { |record| record[:mag] }.sort { |a, b| b <=> a } }
  end

  before :each do
    allow_any_instance_of(UsgsClient).to receive(:fetch_data).and_return data
  end

  describe '#initialize' do
    subject { analyzer }

    it 'should fetch data' do
      expect_any_instance_of(UsgsClient).to receive(:fetch_data)
      subject
    end

    it 'assigns fetched data for later use' do
      expect(analyzer.data).to eql(data)
    end
  end

  describe '#list_california_earthquakes' do
    let(:non_ca_records) do
      [
        { city: 'Alaska' },
        { city: '' },
        { city: nil },
        { city: 'Wyoming' },
      ]
    end

    let(:ca_records) do
      [
        { city: 'CA', mag: 1.01 },
        { city: 'CA', mag: 2.99 },
        { city: 'CA', mag: 1.75 },
        { city: 'CA', mag: 3.45 },
      ]
    end

    let(:data) do
      [
        *non_ca_records,
        *ca_records,
      ].shuffle # to ensure random order of records
    end

    let(:sorted_mags) { sorting_mags.(ca_records) }

    subject { analyzer.list_california_earthquakes }

    it 'should exclude non ca records' do
      expect(subject).not_to include(*non_ca_records)
    end

    it 'should include ca records' do
      expect(subject).to include(*ca_records)
    end

    it 'should sort ca records by mag decreasing' do
      actual_mags = subject.map { |record| record[:mag] }
      expect(actual_mags).to eql(sorted_mags)
    end
  end

  describe '#list_top_us_cities_earthquakes' do
    let(:generate_records) do
      -> (count, city) do
        (1..count).map { { city: city, mag: rand(50) / 10.0 } }
      end
    end

    let(:ca_records) { generate_records.(6, 'CA') }
    let(:hawaii_records) { generate_records.(10, 'Hawaii') }
    let(:alaska_records) { generate_records.(4, 'Alaska') }
    let(:texas_records) { generate_records.(2, 'Texas') }

    let(:data) do
      [
        *ca_records,
        *hawaii_records,
        *alaska_records,
        *texas_records,
      ].shuffle # to ensure random order of records
    end

    subject { analyzer.list_top_us_cities_earthquakes }

    it 'should only include top 3 cities' do
      top_cities_count = ca_records.count + hawaii_records.count + alaska_records.count
      expect(subject.count).to eql(top_cities_count)
    end

    it 'should not include other cities' do
      expect(subject).to_not include(*texas_records)
    end

    it 'should sort them by city highest earthquake count first' do
      expect(subject[0...10]).to include(*hawaii_records)
      expect(subject[10...16]).to include(*ca_records)
      expect(subject[16...20]).to include(*alaska_records)
    end

    it 'should sort them by decreasing mag within each city' do
      sorted_hawaii_mags = sorting_mags.(hawaii_records)
      sorted_ca_mags = sorting_mags.(ca_records)
      sorted_alaska_mags = sorting_mags.(alaska_records)

      get_mags = -> (records) { records.map { |record| record[:mag] } }
      expect(get_mags.(subject[0...10])).to eql(sorted_hawaii_mags)
      expect(get_mags.(subject[10...16])).to eql(sorted_ca_mags)
      expect(get_mags.(subject[16...20])).to eql(sorted_alaska_mags)
    end

    # it 'should only include us cities'
  end
end
