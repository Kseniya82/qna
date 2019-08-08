Rails.application.routes.draw do

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
      resources :questions, only:%i[index show]
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
  end
  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'

end
