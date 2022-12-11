class AddTaxCategoryToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :tax_category, null: false, foreign_key: true
  end
end
