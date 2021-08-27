# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_27_090752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fridge_items", force: :cascade do |t|
    t.integer "ingredient_id"
    t.float "ingredient_quantity"
    t.string "measurement"
  end

  create_table "ingredients", force: :cascade do |t|
    t.text "name"
    t.string "measurement"
    t.string "preposition"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
    t.float "needed"
    t.string "measurement"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name"
    t.integer "people_quantity"
  end

end
