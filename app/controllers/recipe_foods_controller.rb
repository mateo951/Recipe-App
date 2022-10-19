class RecipeFoodsController < ApplicationController
  def new
    @ingredient = RecipeFood.new
    @recipe_id = params[:recipe_id]
  end

  def destroy
    ingredient = RecipeFood.find(params[:id])
    recipe = params[:recipe_id]
    ingredient.destroy
    redirect_to recipe_path(id: recipe), notice: "Ingedient: #{ingredient.food.name} deleted", status: 303
  end

  def create
    @ingredient = RecipeFood.new(permitted_parameters_ingredient)
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient.recipe = @recipe
    if @ingredient.valid?
      @ingredient.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to recipe_path(@recipe), status: 303 }
      end
      return
    end
    redirect_to recipe_path(@recipe)
  end

  def edit
    @ingredient = RecipeFood.find(params[:id])
  end

  def update
    ingredient_id = params[:id]
    quantity = params[:recipe_food][:quantity]
    ingredient = RecipeFood.find(ingredient_id)
    ingredient.quantity = quantity
    if ingredient.valid?
      ingredient.save
      redirect_to recipe_path(id: ingredient.recipe.id), status: 303
      return
    end
    redirect_to recipe_path(id: params[:recipe_id]), status: 303
  end

  private

  def permitted_parameters_ingredient
    params.require(:recipe_food).permit(:food_id, :quantity)
  end
end
