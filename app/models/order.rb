class Order < ApplicationRecord
  # associations
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  # validations
  validates :customer_name, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :customer_mobile, length: { is: 10 }
  validate :has_order_items

  # callbacks
  before_save :calculate_order_item_price_and_tax
  # to calculate and save grand total of all order_items
  after_save :save_grand_total

  def customer_details
    "#{customer_name},\n#{customer_email},\n#{customer_mobile}"
  end

  private

  def save_grand_total
    total = order_items.sum(:total_price)
    return if grand_total == total

    update(grand_total: total)
  end

  def calculate_order_item_price_and_tax
    discounted_items = {}
    self.order_items.each do |order_item|
      discount = Discount.find_by(base_item_id: order_item.item_id)
      if discount.present? && order_item.quantity >= discount.base_item_quantity
        qty_multiplier = (discount.base_item_id == discount.child_item_id) ? 2 : 1
        discount_multiplier = order_item.quantity / (discount.base_item_quantity * qty_multiplier)

        d_total_qty_cal = discount.child_item_quantity * discount_multiplier
        d_total_qty_cal = d_total_qty_cal >= order_item.quantity ? order_item.quantity : d_total_qty_cal

        d_total_qty = (d_total_qty_cal * discount.discount_percent) / 100
        discounted_items[discount.child_item_id] = discounted_items[discount.child_item_id] ? discounted_items[discount.child_item_id] + d_total_qty : d_total_qty
      end

      # order_item (base) price, tax calculation
      total = order_item.item.price * order_item.quantity
      tax = (order_item.item.tax_category.tax_rate.to_f * total ) / 100
      order_item.tax_value = tax
      order_item.total_price = total + tax
    end

    if discounted_items.present?
      discounted_items.each do |child_item_id, discounted_qty|
        order_item = self.order_items.select{ |order_item| order_item.item_id == child_item_id }.first
        if order_item
          total_qty = order_item.quantity
          item = Item.find(child_item_id)
          total_oi_price = item.price * total_qty
          discounted_oi_price = item.price * discounted_qty
          total_price = total_oi_price - discounted_oi_price
          tax = (item.tax_category.tax_rate.to_f * total_price) / 100
          order_item.tax_value = tax
          order_item.total_price = total_price + tax
        end
        discounted_items.delete(child_item_id)
      end
    end
  end

  def has_order_items
    errors.add(:base, "No items added") unless self.order_items.present?
  end
end
