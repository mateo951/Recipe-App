Rails.application.routes.draw do
  resources :tweets
  devise_for :users
  root 'tweets#index'
  get 'public_recipes', to: 'public_recipes#index'
  get 'shopping_list', to: 'shopping_list#index', as: 'shopping_list'
  
  post 'toggle_public', to: 'recipes#toggle', as: 'toggle_public'
  delete 'recipe_delete_ingredient', to: 'recipes#delete_ingredient', 
    as: 'delete_ingredient'
  post 'recipe_add_ingredient', to: 'recipes#add_ingredient',
    as: 'add_ingredient'
  post 'recipe_change_ingredient', to: 'recipes#change_ingredient',
    as: 'change_ingredient'
  resources :users
  resources :recipes, only: %i[index show new create destroy] do
    resources :recipe_foods, only: %i[create destroy]
  end
  resources :foods, only: %i[index show new create destroy]
  resources :foods, only: %i[index new create destroy] do
    resources :recipe_foods, only: %i[create destroy]
  end
end
