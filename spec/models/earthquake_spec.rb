require 'rails_helper'

RSpec.describe Earthquake, type: :model do
  let(:attrs) do
    {
      usgs_id: "ci38167848",
      magnitude: 4.49,
      place: "11km N of Cabazon, CA",
      city: "CA",
      happened_at: Time.parse("2018-05-12 19:34:16 UTC"),
      timezone: -480
    }
  end

  let(:earthquake) { described_class.new(attrs) }

  describe 'validations' do
    subject { earthquake }
    it { is_expected.to be_valid }

    it 'usgs_id should be unique' do
      described_class.create(attrs)
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(usgs_id: ["has already been taken"])
    end

    it 'should be invalid without a usgs_id' do
      earthquake.usgs_id = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(usgs_id: ["can't be blank"])
    end

    it 'should be invalid without a place' do
      earthquake.place = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(place: ["can't be blank"])
    end

    it 'should be invalid without a city' do
      earthquake.city = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(city: ["can't be blank"])
    end

    it 'should be invalid without a happened_at' do
      earthquake.happened_at = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(happened_at: ["can't be blank"])
    end

    it 'should be invalid without a timezone' do
      earthquake.timezone = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages).to include(timezone: ["can't be blank"])
    end

    it 'should be invalid without a magnitude' do
      earthquake.magnitude = nil
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages[:magnitude]).to include("can't be blank")
    end

    it 'should be invalid if magnitude is not a number' do
      earthquake.magnitude = "test"
      expect(earthquake).not_to be_valid
      expect(earthquake.errors.messages[:magnitude]).to include("is not a number")
    end
  end
end
