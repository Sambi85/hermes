Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  namespace :api do
    namespace :v1 do
      resources :messages, only: [:create, :show, :destroy]
      resources :users, only: [:create, :show, :destroy]
      resources :conversations, only: [:create, :show, :destroy] do
        resources :messages, only: [:create, :index, :show, :destroy]
      end
    end
  end
  
  root "conversations#index"

  resources :users, only: [:index, :show]
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create, :index, :show, :destroy]
  end

  # get 'debug_chat', to: 'conversations#debug_chat'  # This would show all messages or data for debugging
end
