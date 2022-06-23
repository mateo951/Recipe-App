require 'rails_helper'

RSpec.describe 'Recipe details page test', type: :feature do
  before :all do
    @user ||= User.create(
      name: 'Victor',
      email: 'victorperaltagomez@gmail.com',
      password: '121212'
    )
    @public_recipe = Recipe.create(
      name: 'Huevos a la mexicana',
      description: 'The healthy choice',
      user: @user, public: true
    )
    @private_recipe = Recipe.create(
      name: 'Enchiladas',
      description: 'Traditional mexican food',
      user: @user, public: false
    )
    @food1 = Food.create(name: 'Bread', measurementUnit: 'Piece', price: 1.00, user: @user)
    @food2 = Food.create(name: 'Egg', measurementUnit: 'Piece', price: 1.00, user: @user)
    @recipe_food1 = RecipeFood.create(food: @food1, quantity: 2, recipe: @public_recipe)
    @recipe_food2 = RecipeFood.create(food: @food2, quantity: 2, recipe: @public_recipe)
  end

  after :all do
    @recipe_food1.destroy
    @recipe_food2.destroy
    @food1.destroy
    @food2.destroy
    @public_recipe.destroy
    @private_recipe.destroy
    @user.destroy
  end
  before :each do
    visit root_path
    fill_in 'user_email', with: 'victorperaltagomez@gmail.com'
    fill_in 'user_password', with: '121212'
    click_button 'Log in'
    visit recipe_path(id: @public_recipe)
  end
  it "Recipe's details should be present" do
    expect(page).to have_content("Preparation time: #{@public_recipe.preparationTime} minutes") &&
                    have_content("Cooking time: #{@public_recipe.preparationTime} minutes") &&
                    have_content(@public_recipe.name)
  end
  it 'List of ingredients should be present' do
    RecipeFood.where(recipe_id: @public_recipe.id).each do |ingredient|
      expect(page).to have_content(ingredient.food.name)
    end
  end
  it 'Buttons to make private, add ingredient and generate shopping list must be present' do
    expect((page.has_button?('Make private') &&
            page.has_button?('Generate shopping list') &&
            page.has_button?('Add ingredient'))).to be true
  end
  it 'Clicking make private/make public button toggles the public attribute' do
    click_button('Make private')
    recipe = Recipe.find(@public_recipe.id)
    expect(recipe.public).to be false
    click_button('Make public')
    recipe = Recipe.find(@public_recipe.id)
    expect(recipe.public).to be true
  end
  it 'Clicking generate shopping list renders Shopping List page' do
    click_button('Generate shopping list')
    expect(page).to have_content('Shopping List')
  end
end
