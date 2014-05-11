class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = env['omniauth.auth']
    if auth_hash
      email = auth_hash["info"]["email"] 
      name = auth_hash["info"]["name"]
      uid = auth_hash["uid"]
      provider = auth_hash['provider']
    end

    if signed_in? && auth_hash
      if Auth.already_linked?(email)
        flash[:alert] = "That account has already been linked!"
        redirect_to current_user
      else
        add_auth_to_profile(uid, provider, name, email) #then redirects to user
      end
    else
      if auth_hash
        find_or_create_auth(uid, provider, name, email) #then redirects to user
      else
        standard_sign_in(params[:email], params[:password]) #then redirects to user
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
