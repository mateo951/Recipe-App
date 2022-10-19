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
    @recipe = Recipe.new(permitted_parameters_recipe)
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
    @ingredient = RecipeFood.new
    @recipes = Recipe.all
  end

  def toggle_public
    @recipe = Recipe.find(params[:id])
    @recipe.public = !@recipe.public
    @recipe.save
    @recipe.public
    render 'recipes/status_changed'
  end

  def delete_ingredient
    ingredient = RecipeFood.find(params[:ingredient])
    recipe = ingredient.recipe_id
    ingredient.destroy
    redirect_to recipe_path(id: recipe), notice: "Ingedient: #{ingredient.food.name} deleted", status: 303
  end
  
  def new_ingredient
    @ingredient = RecipeFood.new
    @recipe = params[:id]
    render "add_ingredient"
  end

  def add_ingredient
    @recipe = Recipe.find(params[:id])
    puts "The params are #{params}"
    @ingredient = RecipeFood.new(permitted_parameters_ingredient)
    @ingredient.recipe = @recipe
    if @ingredient.valid?
      @ingredient.save
      respond_to do |format|
        format.turbo_stream
        format.html {redirect_to recipe_path(id: @recipe.id), status: 303}
      end
      return
    end
    redirect_to recipe_path(id: @recipe.id), alert: 'There was an error adding the ingredient'
  end

  def change_ingredient
    @ingredient = RecipeFood.find(params[:id])
    render 'modify_ingredient'
  end

  def update_ingredient
    ingredient_id = params[:id]
    quantity = params[:recipe_food][:quantity]
    ingredient = RecipeFood.find(ingredient_id)
    ingredient.quantity = quantity
    if ingredient.valid?
      ingredient.save
      flash.now[:notice]= "ok"
      redirect_to recipe_path(id: ingredient.recipe.id), status: 303
      return
    end
    redirect_to recipe_path(id: params[:recipe_id]), status: 303,
                alert: 'There was an error changing the ingredient'
  end

  private

  def permitted_parameters_recipe
    params.require(:recipe).permit(:name, :description, :cookingTime,
                                   :preparationTime, :public)
  end

  def permitted_parameters_ingredient
    params.require(:recipe_food).permit(:food_id, :quantity)
  end
end
