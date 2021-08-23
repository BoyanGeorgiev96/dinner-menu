class CreateFridgeItems < ActiveRecord::Migration[6.1]
  def change
    create_table :fridge_items do |t|
      t.integer :ingredient_id
      t.float :ingredient_quantity
      t.string :measurement
    end
  end
end
