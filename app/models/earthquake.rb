class Earthquake < ApplicationRecord
  validates :usgs_id, presence: true, uniqueness: true
  validates :place, presence: true
  validates :city, presence: true
  validates :happened_at, presence: true
  validates :timezone, presence: true
  validates :magnitude, presence: true, numericality: true

  scope :in, -> (city) { where(city: city) }
  scope :sorted, -> { order(magnitude: :desc) }
end
