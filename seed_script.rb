# frozen_string_literal: true

require 'json'
file = 'recipes.json'
json_array = []
File.readlines(file).each do |line|
  new_line = JSON.parse(line)
  json_array << new_line
end
seed_file = File.new('seed_file.rb', 'w')
items = []
recipe_id = 0
ingredient_id = 0
json_array.each do |line|
  recipe_id += 1
  seed_file.write("Recipe.create(name: \"#{line['name'].gsub('"', "'")}\", people_quantity: #{line['people_quantity']})\n")
  line['ingredients'].each do |ingredient|
    ingredient.gsub!('"', "'")
    preposition = 'nil'
    quantity_and_measurement = String(ingredient.match('[^\s]+'))
    item_name = String(ingredient.match('(?<=\s).*'))
    if item_name[0..2] == 'de '
      preposition = 'de '
      item_name = item_name[3..]
    elsif item_name[0..1] == "d'"
      preposition = "d'"
      item_name = item_name[2..]
    elsif item_name[0..1] == 'à '
      preposition = 'à '
      item_name = item_name[2..]
    end
    measurement = quantity_and_measurement.match('[^\d]+$') || 'nil'
    ingredient_index = items.find_index(item_name)
    if ingredient_index
      ingredient_id = ingredient_index + 1
    elsif item_name != ''
      seed_file.write(%(Ingredient.create(name: "#{item_name}", measurement: "#{measurement}", preposition: "#{preposition}")\n))
      items << item_name
      ingredient_id = items.length
    end
    quantity = String(quantity_and_measurement.match('(.+\d)') || quantity_and_measurement.match('\d'))
    slash_index = quantity.index('/')
    quantity = quantity[0...slash_index].to_f / quantity[slash_index + 1..].to_f if slash_index
    if quantity.to_f != 0.0
      seed_file.write("RecipeIngredient.create(recipe_id: #{recipe_id}, ingredient_id: #{ingredient_id}, quantity: #{quantity})\n")
    end
  end
end
seed_file.close
