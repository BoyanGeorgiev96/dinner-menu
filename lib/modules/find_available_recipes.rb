# Find all available recipes with the current fridge items
module FindAvailableRecipes
  def find_available_recipes
    fridge_items = FridgeItem.all
    @ingredient_ids = fridge_items.pluck(:ingredient_id)
    @ingredients_like_ids = []
    @ingredient_ids.each do |id|
      @ingredients_like_ids << find_ingredients_like(id)
    end
    @ingredients_like_ids.flatten!

    @available_ingredients = RecipeIngredient.where(ingredient_id: @ingredients_like_ids)
    @recipe_ids = @available_ingredients.pluck(:recipe_id).uniq
    @available_recipe_ids = []

    @recipe_ids.each do |recipe_id|
      recipe_ingredients = RecipeIngredient.where(recipe_id: recipe_id).pluck(:ingredient_id)
      next unless (recipe_ingredients - @ingredients_like_ids).empty?
        @available_recipe_ids << recipe_id
    end
    
    Recipe.find(@available_recipe_ids)
  end

  def find_ingredients_like(id)
    Ingredient.where("name ILIKE ?", "%#{Ingredient.find(id).name}%").pluck(:id)
  end
end
#TODO: change fridge item - remove ingredient quantity, add cookable to recipe