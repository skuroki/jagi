Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  resource :user_profile, only: [:show, :edit, :update]
  resource :quiz, only: [:show] do
    member do
      post :answer
    end
  end

  root to: 'home#welcome'
end
