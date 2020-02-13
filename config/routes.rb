Rails.application.routes.draw do
  get 'home/index'
 # namespace :admin do
 # 	resources :projets
 # 	resources :users
 # end
 # 	resources :secteur
 # 	resources :pft
 #  resources :filiere

  
   root to: 'home#index'
   devise_for :users
   resources :projets
   get '/search' => 'projets#search', :as => 'search_projet'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
