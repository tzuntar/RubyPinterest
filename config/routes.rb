Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    get '/user/preferences' => 'devise/registrations#edit', as: 'user_preferences'
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :boards
  resources :pins
  get '/user/:user_id/boards', to: 'boards#index_by_user'
  get '/user/:user_id/pins', to: 'pins#index_by_user'
  get '/search', to: 'search#show', as: 'search'

  # Defines the root path route ("/")
  root "pins#index"
end
