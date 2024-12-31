Rails.application.routes.draw do

  resources :conversations, only: [:show] do
    get 'debug/chat/:id', to: 'chat#show', as: 'debug_chat'  #custom route for debugging chat in browser
  end

  mount ActionCable.server => '/cable'
end
