class Earthquake < ApplicationRecord
  validates :usgs_id, presence: true, uniqueness: true
  validates :place, presence: true
  validates :city, presence: true
  validates :happened_at, presence: true
  validates :magnitude, presence: true, numericality: true
end
