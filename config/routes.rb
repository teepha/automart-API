Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    get "/all_cars" => "cars#all_cars"
    get "/cars/body_type" => "cars#search_by_body_type"
    resources :cars do
      resources :orders
      put "/orders/:id/status" => "orders#update_status"
      resources :flags
    end
  end
end
