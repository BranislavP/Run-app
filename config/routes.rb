Rails.application.routes.draw do
  resources :runs
  devise_for :users
  root 'runs#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
