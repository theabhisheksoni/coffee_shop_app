class AddCustomerDetailsToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :customer_name, :string
    add_column :orders, :customer_email, :string
    add_column :orders, :customer_mobile, :string
  end
end
