Rails.application.routes.draw do
  devise_for :users
  root 'public_recipes#index'
  resources :public_recipes, only:[:index]
  resources :shopping_list, only: [:index]
  resources :users
  resources :recipes, only: %i[index show new create destroy] do
    member do
      post :toggle_public
      delete :delete_ingredient
      get :new_ingredient
      post :add_ingredient
      get :change_ingredient
      patch :update_ingredient
    end
    resources :recipe_foods, only: %i[create destroy] 
  end
  resources :foods, only: %i[index show new create destroy]
  resources :foods, only: %i[index new create destroy] do
    resources :recipe_foods, only: %i[create destroy]
  end
end
