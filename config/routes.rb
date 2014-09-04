Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'entries#index'
  resources :entries do
    post 'search', on: :collection
  end
  resources :users

  #home
  get '/disqus', to: "home#disqus"
end
