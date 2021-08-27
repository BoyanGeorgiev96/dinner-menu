# Find all available recipes with the current fridge items
module FindAvailableRecipes
  def find_available_recipes
    @fridge_items = FridgeItem.all
    @fridge_item_ids = @fridge_items.pluck(:ingredient_id)
    @grouped_fridge_items = @fridge_items.group_by(&:ingredient_id)
    @available_recipe_ids = []
    @recipe_ingredients = RecipeIngredient.where(recipe_id: RecipeIngredient.where(ingredient_id: FridgeItem.pluck(:ingredient_id)).pluck(:recipe_id)).group_by(&:recipe_id)
    @recipe_ingredients.each do |recipe_id, ingredients|
      enough_quantity = true
      next unless (ingredients.pluck(:ingredient_id) - @fridge_item_ids).empty?

      ingredients.group_by(&:ingredient_id).each do |ingredient_id, ingredient|
        next unless @grouped_fridge_items[ingredient_id][0].ingredient_quantity < ingredient[0].needed

        enough_quantity = false
        puts "#{@grouped_fridge_items[ingredient_id][0].ingredient_quantity} quantity, #{ingredient[0].needed} needed"
      end
      @available_recipe_ids << recipe_id if enough_quantity
    end
    Recipe.find(@available_recipe_ids)
  end
end
