Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :todos do
    resources :items
  end

  resources :users, only: [:index, :show]
  post '/signup', to: 'auth#signup'
  post '/auth/login', to: 'auth#login'
  get '/auth/logout', to: 'auth#logout'
end