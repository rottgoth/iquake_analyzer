class Earthquake < ApplicationRecord
  validates :usgs_id, presence: true, uniqueness: true
  validates :place, presence: true
  validates :city, presence: true
  validates :happened_at, presence: true
  validates :timezone, presence: true
  validates :magnitude, presence: true, numericality: true

  scope :in, -> (city) { where(city: city) }
  scope :sorted, -> { order(magnitude: :desc) }

  def self.top_us_cities
    cities = Earthquake.select("*, COUNT(city)")
                       .group('city')
                       .order("count(city) desc")
                       .limit(3)
                       .pluck(:city)

    cities.reduce([]) do |acc, current_city|
      acc.concat(Earthquake.in(current_city).sorted)
    end
  end

  def formatted_happened_at
    happened_at.strftime("%Y-%m-%dT%H:%M:%S%:z")
  end
end
