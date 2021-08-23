class FridgeItemsController < ApplicationController
  before_action :set_fridge_item, only: %i[ show edit update destroy ]

  # GET /fridge_items or /fridge_items.json
  def index
    @fridge_items = FridgeItem.all
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
    @fridge_item = FridgeItem.new(fridge_item_params)

    respond_to do |format|
      if @fridge_item.save
        format.html { redirect_to @fridge_item, notice: "Fridge item was successfully created." }
        format.json { render :show, status: :created, location: @fridge_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fridge_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fridge_items/1 or /fridge_items/1.json
  def update
    respond_to do |format|
      if @fridge_item.update(fridge_item_params)
        format.html { redirect_to @fridge_item, notice: "Fridge item was successfully updated." }
        format.json { render :show, status: :ok, location: @fridge_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fridge_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fridge_items/1 or /fridge_items/1.json
  def destroy
    @fridge_item.destroy
    respond_to do |format|
      format.html { redirect_to fridge_items_url, notice: "Fridge item was successfully destroyed." }
      format.json { head :no_content }
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
