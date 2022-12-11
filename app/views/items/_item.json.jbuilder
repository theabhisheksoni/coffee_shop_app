json.extract! item, :id, :name, :price, :availability, :tax_category_id, :created_at, :updated_at
json.url item_url(item, format: :json)
