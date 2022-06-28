Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :comments, only: [:show] do
        resources :likes, only: [:create]
      end
      resources :posts, only: [:create, :index, :show] do
        resources :likes, only: [:create]
        resources :comments, only: [:create]
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
