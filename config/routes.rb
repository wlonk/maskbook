Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/search', to: 'search#search'
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users
  resources :villains
end
