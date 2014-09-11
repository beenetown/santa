Santa::Application.routes.draw do
  resources :groups do
    resources :memberships, only: :destroy
  end

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

  resources :select_dates, only: [:new, :edit, :update]
  post "select_dates/:id", to: "select_dates#create"

  resources :open_dates, only: [:new, :edit, :update]
  post "open_dates/:id", to: "open_dates#create"

  resources :spending_limits, only: [:new, :edit, :update]
  post "spending_limits/:id", to: "spending_limits#create"
  
  resources :users do 
    resources :auths, only: [:edit, :update, :index]
  end

  get "signup", to: "auths#new"


  root "static#home"
  get "help", to: "static#help"
end
