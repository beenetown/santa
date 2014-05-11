Santa::Application.routes.draw do
  resources :groups#, except: [:index]
  post "add_user",    to: "groups#add_user"
  post "invite_user", to: "groups#invite_user"
  post "select_date", to: "groups#select_date"
  post "open_date",   to: "groups#open_date" 

  get "static/home"
  get "static/help"

  resources :sessions, only: [:new, :create, :destroy]
  get "signin",     to: "sessions#new"
  delete "signout", to: "sessions#destroy"

  resources :auths, only: [:new, :create, :edit, :update, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/google', to: redirect('/auth/google_oauth2')
  get '/auth/failure', to: redirect('/')

  # get 'signin_google'

  resources :users do 
    resources :auths
  end

  get "signup", to: "auths#new"

  post "accept_invite", to: "users#accept_invite"

  root "static#home"

end
