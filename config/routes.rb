Howard::Application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/incoming_message', to: 'message#incoming_message'
end
