Rails.application.routes.draw do

  devise_for :admins
  	
  	get '/search_article' => 'welcome#search_article', :as => :search_article
  	get '/search' => 'welcome#search', :as => :search
	post '/filter' => 'welcome#filter', :as => :filter
	get '/sort_by' => 'welcome#sort_by'

	resources :tags

	get 'welcome/like' => 'welcome#like'
	
	resources :articles do
	  	resources :comments
	end

  	get 'welcome/index'
  	root to: 'welcome#index'
  	#devise_for :users, controllers: { sessions: 'users/sessions' }
  	devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

	
	namespace :users do
		get 'articles' => 'articles#index'
		get 'articles/:id' => 'articles#show'
	end

	resources :categories
end
