Howard::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
  end

  root to: 'home#index'
  get '/incoming_message', to: 'message#incoming_message'
  get '/sms_all', to: 'message#sms_all'
  get '/config', to: 'home#index'
  resources :notes
  resources :lists
  resources :users

  match 'users/:id' => 'users#destroy', :via => :delete, :as => :destroy_user

  get '/meet_howard', to: 'home#splash', as: 'splash'

end
