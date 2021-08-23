json.extract! fridge_item, :id, :ingredient_id, :ingredient_quantity, :measurement, :created_at, :updated_at
json.url fridge_item_url(fridge_item, format: :json)
