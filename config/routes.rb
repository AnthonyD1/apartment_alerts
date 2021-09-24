Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'dashboard#show'

  resource :dashboard, only: :show, controller: 'dashboard'
  resources :alerts do
    member do
      post :refresh
    end
  end
  resources :craigslist_posts, only: [:update, :destroy] do
    post :favorite, on: :member
    patch :batch_delete, on: :collection
  end
end
