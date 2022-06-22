class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all.where(user: current_user)
  end

  def destroy
    recipe = Recipe.find(params[:id])
    flash[:notice] = "#{recipe.name} was successfully deleted"
    recipe.destroy
    redirect_to recipes_path
  end

  def new
    @recipe = Recipe.new
  end

  def create
    puts "Parametros: #{permitted_parameters}"
    @recipe = Recipe.new(permitted_parameters)
    @recipe.user = current_user
    if @recipe.valid?
      @recipe.save
      redirect_to recipes_path, notice: "Recipe: #{@recipe.name} created successfully"
      return
    end
    redirect_to new_recipe_path
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.recipe_foods.includes([:food])
  end

  def toggle
    recipe = Recipe.find(params[:id])
    puts recipe.public
    recipe.public = !recipe.public
    recipe.save
    recipe.public
    redirect_to recipe_path(id: params[:id])
  end

  def delete_ingredient
    ingredient = RecipeFood.find(params[:ingredient])
    ingredient.destroy
    redirect_to recipe_path(id: params[:id]), notice: "Ingedient: #{ingredient.food.name} deleted"
  end

  def permitted_parameters
    params.require(:recipe).permit(:name, :description, :cookingTime,
                                   :preparationTime, :public)
  end
end
