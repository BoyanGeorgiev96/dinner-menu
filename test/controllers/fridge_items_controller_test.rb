require "test_helper"

class FridgeItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fridge_item = fridge_items(:one)
  end

  test "should get index" do
    get fridge_items_url
    assert_response :success
  end

  test "should get new" do
    get new_fridge_item_url
    assert_response :success
  end

  test "should create fridge_item" do
    assert_difference('FridgeItem.count') do
      post fridge_items_url, params: { fridge_item: { ingredient_id: @fridge_item.ingredient_id, ingredient_quantity: @fridge_item.ingredient_quantity, measurement: @fridge_item.measurement } }
    end

    assert_redirected_to fridge_item_url(FridgeItem.last)
  end

  test "should show fridge_item" do
    get fridge_item_url(@fridge_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_fridge_item_url(@fridge_item)
    assert_response :success
  end

  test "should update fridge_item" do
    patch fridge_item_url(@fridge_item), params: { fridge_item: { ingredient_id: @fridge_item.ingredient_id, ingredient_quantity: @fridge_item.ingredient_quantity, measurement: @fridge_item.measurement } }
    assert_redirected_to fridge_item_url(@fridge_item)
  end

  test "should destroy fridge_item" do
    assert_difference('FridgeItem.count', -1) do
      delete fridge_item_url(@fridge_item)
    end

    assert_redirected_to fridge_items_url
  end
end
