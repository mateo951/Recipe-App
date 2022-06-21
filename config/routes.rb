Rails.application.routes.draw do
  devise_for :users
  root 'recipes#index'
  get 'public_recipes', to: 'public_recipes#index'
  
  post 'toggle_public', to: 'recipes#toggle', as: 'toggle_public'
  post 'recipe_delete_ingredient', to: 'recipes#delete_ingredient', as: 'delete_ingredient'
  
  resources :users
  resources :recipes, only: %i[index show new create destroy] do
    resources :recipe_foods, only: %i[create destroy]
  end
  resources :foods, only: %i[index show new create destroy]
  resources :foods, only: %i[index new create destroy] do
    resources :recipe_foods, only: %i[create destroy]
  end
end
