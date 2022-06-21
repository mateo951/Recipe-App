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

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.recipe_foods
  end

  def toggle
    recipe = Recipe.find(params[:id])
    puts recipe.public
    recipe.public = !recipe.public
    recipe.save
    recipe.public
    redirect_to recipe_path(id: params[:id])
  end
end
