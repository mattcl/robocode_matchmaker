RobocodeMatchmaker::Application.routes.draw do

  get "zip/starter_package"

  get "learn/index"

  get "learn/first_bot"

  resources :matches
  resources :bots

  get "home/index"

  devise_for :users
  get 'users' => 'users#index'
  get 'users/:id' => 'users#show', :as => 'user'

  namespace :api, :defaults => { :format => 'json' } do
    resources :matches
  end

  get "/pages/*id" => 'pages#show', :as => :page, :format => false

  root :to => 'pages#show', :id => 'getting_started'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
