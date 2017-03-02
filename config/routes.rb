Rails.application.routes.draw do
  root   'static_pages#home'
  devise_for(
    :users,
    controllers: { registrations: 'registrations', omniauth_callbacks: 'callbacks' }
  )
  resources :villains
  post '/villains/:id/favorite', to: 'villains#favorite'
  get '/tags', to: 'villains#all_tags'
end
