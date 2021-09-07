class FridgeItemsController < ApplicationController
  before_action :set_fridge_item, only: %i[ show edit update destroy ]
  include FindAvailableRecipes
  # GET /fridge_items or /fridge_items.json
  def index
    @fridge_items = FridgeItem.all
    @fridge_item = FridgeItem.new
    @ingredients_data = Ingredient.all
    @ingredient_names = @ingredients_data.pluck(:name)
    @ingredients = @ingredients_data.group_by(&:id)
    @available_recipes = find_available_recipes
  end

  # GET /fridge_items/1 or /fridge_items/1.json
  def show
  end

  # GET /fridge_items/new
  def new
    @fridge_item = FridgeItem.new
  end

  # GET /fridge_items/1/edit
  def edit
  end

  # POST /fridge_items or /fridge_items.json
  def create
    @on_fridge_items_page = !params[:on_recipe_page]
    @enough_ingredients = false
    ingredient_names = fridge_item_params[:ingredient_id].split(',').map(&:strip)
    @new_ingredients = {}
    ingredient_names.each do |ingredient_name|
      @ingredient = if @on_fridge_items_page
                      Ingredient.find_by_name(ingredient_name)
                    else
                      Ingredient.find(params[:ingredient_id])
                    end
      @item_exists = false
      if @ingredient
        @fridge_item = FridgeItem.find_by ingredient_id: @ingredient.id
        if @fridge_item
          respond_to do |format|
            @item_exists = true
            format.html { redirect_to fridge_item, notice: 'Fridge item already exists.' }
            format.js { flash.now[:notice] = "Fridge item already exists." }
            format.json { render :show, status: :created, location: @fridge_item }
          end
        else
          new_params = {ingredient_id: @ingredient.id}
          @fridge_item = FridgeItem.new(new_params)

          respond_to do |format|
            if @fridge_item.save
              @new_ingredients[@ingredient.id] = [@fridge_item, @ingredient.name]
              format.html { redirect_to @fridge_item, notice: 'Fridge item was successfully created.' }
              format.js { flash.now[:notice] = "Fridge items successfully added." }
              format.json { render :show, status: :created, location: @fridge_item }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.js { flash.now[:notice] = 'Ingredient does not exist!' }
              format.json { render json: @fridge_item.errors, status: :unprocessable_entity }
            end
          end
        end

      else
        respond_to do |format|
          format.js { flash.now[:notice] = 'Ingredient does not exist!' }
        end
      end
    end
  end

  # PATCH/PUT /fridge_items/1 or /fridge_items/1.json
  def update
    @ingredient = Ingredient.find(@fridge_item.ingredient_id)
    respond_to do |format|
      if @fridge_item.save
        format.html { redirect_to @fridge_item, notice: 'Fridge item was successfully updated.' }
        format.json { render :show, status: :ok, location: @fridge_item }
        format.js { flash.now[:notice] = "#{fridge_item_params[:ingredient_quantity]} #{fridge_item_params[:measurement]} #{@ingredient.name.capitalize} was successfully added to fridge." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fridge_item.errors, status: :unprocessable_entity }
        format.js { flash.now[:notice] = 'Ingredient quantity not added!' }
      end
    end
  end

  # DELETE /fridge_items/1 or /fridge_items/1.json
  def destroy
    @ingredient = Ingredient.find(@fridge_item.ingredient_id)
    @fridge_item.destroy
    respond_to do |format|
      format.html { redirect_to fridge_items_url, notice: "#{@ingredient.name.capitalize} successfully removed from fridge." }
      format.json { head :no_content }
      format.js { flash.now[:notice] = "#{@ingredient.name.capitalize} successfully removed from fridge." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_fridge_item
    @fridge_item = FridgeItem.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def fridge_item_params
    params.require(:fridge_item).permit(:ingredient_id, :ingredient_quantity, :measurement)
  end
end
