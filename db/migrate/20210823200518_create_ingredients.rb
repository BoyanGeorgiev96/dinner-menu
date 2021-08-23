class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.text :name
      t.string :measurement
      t.string :preposition
    end
  end
end
