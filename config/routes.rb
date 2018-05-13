Rails.application.routes.draw do
  resources :earthquakes, only: [:index] do
    get :california_earthquakes, on: :collection, as: :california
    get :top_us_cities_earthquakes, on: :collection, as: :top_us_cities
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'earthquakes#index'
end
