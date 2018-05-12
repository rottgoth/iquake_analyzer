require 'rails_helper'

RSpec.describe IquakeAnalyzer, type: :model do

  let(:analyzer) { IquakeAnalyzer.new }
  let(:data) { [] }
  let(:sorting_mags) do
    -> (records) { records.map(&:magnitude).sort { |a, b| b <=> a } }
  end

  let(:generate_records) do
    -> (count, city) do
      (1..count).map { Earthquake.create(usgs_id: SecureRandom.uuid, place: city, city: city, magnitude: rand(50) / 10.0, timezone: 0, happened_at: 1.day.ago) }
    end
  end

  describe '#list_california_earthquakes' do
    let(:non_ca_records) { generate_records.(2, 'Alaska') }
    let(:ca_records) { generate_records.(4, 'CA') }

    let(:data) do
      [
        *non_ca_records,
        *ca_records,
      ].shuffle # to ensure random order of records
    end

    let(:sorted_mags) { sorting_mags.(ca_records) }

    subject { analyzer.list_california_earthquakes }

    before(:each) do
      allow(analyzer).to receive(:print_formatted_list).with(data) { data }
    end

    it 'should exclude non ca records' do
      expect(subject).not_to include(*non_ca_records)
    end

    it 'should include ca records' do
      expect(subject).to include(*ca_records)
    end

    it 'should sort ca records by mag decreasing' do
      actual_mags = subject.map { |record| record.magnitude }
      expect(actual_mags).to eql(sorted_mags)
    end
  end

  describe '#list_top_us_cities_earthquakes' do
    let(:ca_records) { generate_records.(6, 'CA') }
    let(:hawaii_records) { generate_records.(10, 'Hawaii') }
    let(:alaska_records) { generate_records.(4, 'Alaska') }
    let(:texas_records) { generate_records.(2, 'Texas') }

    let!(:data) do
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

      expect(subject[0...10].map(&:magnitude)).to eql(sorted_hawaii_mags)
      expect(subject[10...16].map(&:magnitude)).to eql(sorted_ca_mags)
      expect(subject[16...20].map(&:magnitude)).to eql(sorted_alaska_mags)
    end

    # it 'should only include us cities'
  end

  describe '#format_earthquake_record' do
    let(:record) do
      Earthquake.new({
        usgs_id: "ci38167848",
        magnitude: 4.49,
        place: "11km N of Cabazon, CA",
        city: "CA",
        happened_at: Time.parse("2018-05-08 11:49:34 UTC"),
        timezone: -480
      })
    end
    let(:formated_earthquake_record) { "2018-05-08T11:49:34+00:00\t|\t11km N of Cabazon, California\t|\tMagnitude: 4.49" }

    subject { analyzer.format_earthquake_record(record) }

    it "should return the proper formatted record" do
      expect(subject).to eql(formated_earthquake_record)
    end

    context 'date/time' do
      it 'should print the date/time properly (UTC): "2018-05-08T11:49:34+00:00"' do
        expect(subject).to start_with("2018-05-08T11:49:34+00:00")
      end

      it 'should format any date with this format "%Y-%m-%dT%H:%M:%S%:z"' do
        record.happened_at = 1.week.ago
        formatted_date = record.happened_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
        actual = analyzer.format_earthquake_record(record)
        expect(actual).to start_with(formatted_date)

        record.happened_at = 1.month.ago
        formatted_date = record.happened_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
        actual = analyzer.format_earthquake_record(record)
        expect(actual).to start_with(formatted_date)
      end
    end

    context 'place' do
      it 'should print the place properly (replacing CA for California)' do
        expect(subject).to include('11km N of Cabazon, California')
      end

      it 'should format any place' do
        record.place = '9km SW of Leilani Estates, Hawaii'
        expect(subject).to include('9km SW of Leilani Estates, Hawaii')
      end
    end

    context 'magnitude' do
      it 'should include "Magnitude: 4.49"' do
        expect(subject).to end_with('Magnitude: 4.49')
      end

      it 'should format any mag' do
        record.magnitude = 0.84
        expect(subject).to end_with('Magnitude: 0.84')
      end
    end
  end

  describe '#print_formatted_list' do
    let(:list) { (1..10).to_a }

    subject { analyzer.print_formatted_list(list) }

    before(:each) do
      list.each do |item|
        allow(analyzer).to receive(:puts)
        allow(analyzer).to receive(:format_earthquake_record).with(item).and_return item.to_s
      end
    end

    it 'should call format_earthquake_record for each item in the list' do
      list.each do |item|
        expect(analyzer).to receive(:format_earthquake_record).with(item)
      end

      subject
    end

    it 'should print the formatted data' do
      formatted_data = list.map(&:to_s) # from stubbed method
      expect(analyzer).to receive(:puts).with(formatted_data)
      subject
    end
  end
end
