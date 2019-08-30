require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    confirmations: 'oauth_confirmations'
  }
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only:%i[index] do
        get :me, on: :collection
      end
      resources :questions, only:%i[index show create update destroy] do
        resources :answers, only:%i[index show create update destroy], shallow: true
      end
    end
  end


  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_destroy
    end
  end

  concern :commentable do
    resources :comments, only: %i[create]
  end

  resources :questions, concerns: %i[votable commentable]  do
    resources :answers, shallow: true, concerns: %i[votable commentable]  do
      patch :best, on: :member
    end
    resources :subscriptions, only: %i[create destroy], shallow: true
  end
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  get :search, to: 'search#results'

  mount ActionCable.server => '/cable'

end
