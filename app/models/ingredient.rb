class Ingredient < ApplicationRecord
  has_many :recipe_ingredient
  has_many :fridge_item
end
