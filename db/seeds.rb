# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


TAX_RATES = [10, 15, 20]
TAX_RATES.each do |tax_rate|
  TaxCategory.create(tax_rate: tax_rate)
end

americano = Item.create(name: 'Americano', price: 100, availability: true, tax_category: TaxCategory.first)
cappuccino = Item.create(name: 'Cappuccino', price: 110, availability: true, tax_category: TaxCategory.first)
cortado = Item.create(name: 'Cortado', price: 120, availability: true, tax_category: TaxCategory.first)
espresso = Item.create(name: 'Espresso', price: 130, availability: true, tax_category: TaxCategory.first)
iced = Item.create(name: 'Iced Coffee', price: 140, availability: true, tax_category: TaxCategory.first)
latte = Item.create(name: 'Latte', price: 150, availability: true, tax_category: TaxCategory.first)

Discount.create(base_item: americano, child_item: cappuccino, base_item_quantity: 2, child_item_quantity: 1, discount_percent: 100)

order_params = {
  "customer_name" => "customer1",
  "customer_email" => "customer1@test.com",
  "customer_mobile" => "1234567890",
  "order_items_attributes" => {
    "0" => {
      "item_id" => "1",
      "quantity" => "2"
    },
    "1" => {
      "item_id" => "2",
      "quantity" => "1"
    }
  }
}

# 2 americano, 1 cappuccino
# discount of 20% should be applied on cappuccino
Order.create(order_params)
