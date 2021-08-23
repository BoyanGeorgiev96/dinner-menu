require "application_system_test_case"

class FridgeItemsTest < ApplicationSystemTestCase
  setup do
    @fridge_item = fridge_items(:one)
  end

  test "visiting the index" do
    visit fridge_items_url
    assert_selector "h1", text: "Fridge Items"
  end

  test "creating a Fridge item" do
    visit fridge_items_url
    click_on "New Fridge Item"

    fill_in "Ingredient", with: @fridge_item.ingredient_id
    fill_in "Ingredient quantity", with: @fridge_item.ingredient_quantity
    fill_in "Measurement", with: @fridge_item.measurement
    click_on "Create Fridge item"

    assert_text "Fridge item was successfully created"
    click_on "Back"
  end

  test "updating a Fridge item" do
    visit fridge_items_url
    click_on "Edit", match: :first

    fill_in "Ingredient", with: @fridge_item.ingredient_id
    fill_in "Ingredient quantity", with: @fridge_item.ingredient_quantity
    fill_in "Measurement", with: @fridge_item.measurement
    click_on "Update Fridge item"

    assert_text "Fridge item was successfully updated"
    click_on "Back"
  end

  test "destroying a Fridge item" do
    visit fridge_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fridge item was successfully destroyed"
  end
end
