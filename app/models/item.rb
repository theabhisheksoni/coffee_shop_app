class Item < ApplicationRecord
  validates :name, presence: true
  scope :available, -> { where(availability: true) }
end
