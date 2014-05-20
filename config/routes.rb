Santa::Application.routes.draw do
  resources :groups do
    resources :memberships, only: :destroy
  end

  # resources :invites
  post "invite_user", to: "invites#create"
  post "accept_invite", to: "invites#destroy"

  resources :group_users
  post "add_user",    to: "group_users#create"


  resources :sessions, only: [:new, :create]
  get "signin",     to: "sessions#new"
  delete "signout", to: "sessions#destroy"

  resources :auths, only: [:new, :create, :update, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/google', to: redirect('/auth/google_oauth2')
  get '/auth/failure', to: redirect('/')

  resources :selection_dates
  post "selection_day", to: "selection_dates#create"
  # get 'edit_selection_date', to: "selection_dates#edit"
  
  resources :open_dates
  post "opening_day",   to: "open_dates#create" 
  # get "edit_open_date", to: "open_dates#edit"

  resources :users do 
    resources :auths, only: [:edit, :update, :index]
  end

  get "signup", to: "auths#new"


  root "static#home"
  get "help", to: "static#help"

end
