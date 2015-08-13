Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :user_profiles, only: [:edit, :update]
  resource :page, only: [:index]
  root to: "page#index"
end
