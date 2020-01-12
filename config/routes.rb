Rails.application.routes.draw do
  root 'users#index'
  devise_for :users
  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create] do
      collection do
        get 'acceptFriend'
        get 'declineFriend'
      end
    end
  end
  resources :posts, only: %i[index new create show destroy] do
      resources :likes, only: %i[create]
  end
  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
