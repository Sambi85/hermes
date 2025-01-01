Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations',
  #   passwords: 'users/passwords',
  #   confirmations: 'users/confirmations',
  #   unlocks: 'users/unlocks',
  #   omniauth_callbacks: 'users/omniauth_callbacks'
  # }

  root "conversations#index"

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :users, only: [:index, :show]

  # get 'debug_chat', to: 'conversations#debug_chat'  # This would show all messages or data for debugging
end
