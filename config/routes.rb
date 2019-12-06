Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  resources :cars do
    resources :orders
    put "/orders/:id/status" => "orders#update_status"
  end
end
