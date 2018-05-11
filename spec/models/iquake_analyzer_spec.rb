require 'rails_helper'

RSpec.describe IquakeAnalyzer, type: :model do

  let(:analyzer) { IquakeAnalyzer.new }
  let(:data) { [] }

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

    let(:sorted_mags) do
      ca_records.map { |record| record[:mag] }
                .sort { |a,b| b <=> a } # decreasing order
    end

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
end
