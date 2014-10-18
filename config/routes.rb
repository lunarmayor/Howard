Howard::Application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/incoming_message', to: 'message#incoming_message'
  get '/sms_all', to: 'message#sms_all'
  get '/config', to: 'home#index'
  resources :notes
  resources :lists
  resources :users

end
