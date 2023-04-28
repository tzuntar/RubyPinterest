Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    get '/user/preferences' => 'devise/registrations#edit', as: 'user_preferences'
    get '/user/saved' => 'bookmarks#index', as: 'user_saved_pins'
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :boards
  resources :pins do
    post 'save', to: 'pins#save'
    post 'unsave', to: 'pins#unsave'
    member do
      put "like", to: "pins#like"
      put "dislike", to: "pins#dislike"
    end
  end

  get '/profiles/:id' => 'users#show', as: 'profile'
  get '/user/:user_id/boards', to: 'boards#index_by_user'
  get '/user/:user_id/pins', to: 'pins#index_by_user'
  get '/search', to: 'search#show', as: 'search'

  # Defines the root path route ("/")
  root "pins#index"
end
