Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tours#index'
  resources :tours
  get '/step1', to: 'tours#step1'
end
