class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  validate :has_order_items
  # to calculate and save grand total of all order_items
  after_save :save_grand_total

  def save_grand_total
    total = order_items.sum(:total_price)
    return if grand_total == total

    update(grand_total: total)
  end

  def has_order_items
    errors.add(:base, "No items added") unless self.order_items.present?
  end
end
