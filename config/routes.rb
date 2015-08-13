Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :user_profiles, only: [:edit, :update]
  resources :page, only: [:index]
  root to: "page#index"
end
