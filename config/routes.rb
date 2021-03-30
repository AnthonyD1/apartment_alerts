Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'dashboard/index'
  root 'dashboard#index'

  resources :alerts do
    member do
      post :refresh
    end
  end
  resources :craigslist_posts, only: [:update, :destroy]
end
