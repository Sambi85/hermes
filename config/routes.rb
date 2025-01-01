Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root "conversations#index"

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :users, only: [:index, :show]

  # Optional: If you want a debug route to list all conversations or messages for testing purposes
  # get 'debug_chat', to: 'conversations#debug_chat'  # This would show all messages or data for debugging
end
