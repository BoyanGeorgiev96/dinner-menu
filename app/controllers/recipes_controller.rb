class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]
  include FindAvailableRecipes

  # GET /recipes or /recipes.json
  def index
    @fridge_item_ids = FridgeItem.pluck(:ingredient_id)
    @available_recipes = find_available_recipes
    @recipes = Recipe.paginate(page: params[:page])
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    recipe_ingredients = RecipeIngredient.where(recipe_id: @recipe[:id])
    recipe_ingredient_ids = recipe_ingredients.pluck(:ingredient_id)
    @recipe_ingredients = recipe_ingredients.group_by(&:ingredient_id)
    @ingredients_like_ids = []
    fridge_items = FridgeItem.all
    fridge_items.each do |fi|
      @ingredients_like_ids << find_ingredients_like(fi.ingredient_id)
    end
    @ingredients_like_ids.flatten!
    @ingredients = Ingredient.find(recipe_ingredient_ids)
    @fridge_item_ids = []
    @ingredients.each do |ingredient|
      if @ingredients_like_ids.include?(ingredient.id)
        @fridge_item_ids << ingredient.id
      end
    end
    @fridge_item = FridgeItem.new
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:name, :people_quantity)
    end
end
