class PublicRecipesController < ApplicationController
  def index
    @users = User.all
    @recipes = Recipe.includes([:user]).where(public: true).where.not(user_id: current_user)
  end
end
