Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tours#index'
  match 'download_ofs', to: 'tours#download_ofs', as: 'download', via: :get
  match 'create_pdf', to: 'tours#create_pdf', as: 'create', via: :get
  resources :tours
end
