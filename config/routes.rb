Rails.application.routes.draw do
  root   'static_pages#home'
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users
  resources :villains
end
