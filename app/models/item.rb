class Item < ApplicationRecord
  validates :name, presence: true
  scope :available, -> { where(availability: true) }
  has_many :order_items, dependent: :destroy
end
