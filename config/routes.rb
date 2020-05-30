Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'services', to: 'pages#services'
  resources :articles
end
