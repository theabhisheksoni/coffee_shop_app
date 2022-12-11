class TaxCategory < ApplicationRecord
  has_many :items
  validates :tax_rate, uniqueness: true, numericality: { in: 0..100, message: "%{value} must be between 0 to 100" }
end
