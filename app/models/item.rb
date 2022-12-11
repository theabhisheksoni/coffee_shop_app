class Item < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  scope :available, -> { where(availability: true) }
  belongs_to :tax_category
end
