Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  resources :rooms, only: [:show]
end
