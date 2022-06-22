class ShoppingListController < ApplicationController
  def index
    @total_items = RecipeFood.select(:food_id).distinct.count
    @total_value = RecipeFood.connection.select_all(
      'SELECT  SUM(quantity * foods.price) '\
      'FROM recipe_foods INNER JOIN foods ON recipe_foods.food_id = foods.id;'
    )[0]['sum']
    @items = RecipeFood.connection.select_all(
      'SELECT name, DT.quantity, "f"."measurementUnit", (DT.quantity * price) as total_price FROM foods AS f '\
      'INNER JOIN(SELECT  food_id, SUM(quantity) as quantity FROM recipe_foods INNER JOIN foods ON '\
      'recipe_foods.food_id = foods.id group by food_id)as DT ON f.id = DT.food_id'
    )
  end
end
