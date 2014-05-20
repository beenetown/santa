class AuthsController < ApplicationController
  before_action :set_auth, only: [:update, :destroy]
  before_action :correct_user, except: [:new, :create] #need to implement
  before_action :signed_in_user, except: [:new, :create]

  def index
    @auths = Auth.where(user_id: params[:user_id]).to_a
    @user = User.find(params[:user_id])
  end

  def new    
    @auth = Auth.new()
  end

  def create
    user = User.create()
    @auth = Auth.new(provider: "santa", 
                     user_id: user.id, 
                     name: params[:auth][:name],
                     email: params[:auth][:email],
                     password: params[:auth][:password],
                     password_confirmation: params[:auth][:password_confirmation]
                     )

    respond_to do |format|
      if @auth.save 
        sign_in user
        # authMailer.signup_confirmation(@auth).deliver
        format.html { redirect_to @auth.user, notice: 'Welcome to Secret Santa App!' }
        format.json { render action: 'show', status: :created, location: @auth }
      else
        user.destroy
        format.html { render action: 'new' }
        format.json { render json: @auth.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @auth = Auth.find(params[:id])
    @user = User.find(params[:user_id])
    
    if @auth.provider != 'santa'
      flash[:alert] = "That account must be updated through #{@auth.provider.split('_').first.capitalize}."
      redirect_to user_auths_path(current_user)
    end
  end

  def update
    @user = User.find(params[:user_id])
    @auth.user.update(guest: false)
    
    respond_to do |format|
      if @auth.update(auth_params)
        format.html { redirect_to current_user, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @auth.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def set_auth
      @auth = Auth.find(params[:id])
    end

    def correct_user
      @user = User.find(params[:user_id]) if params[:user_id]
      unless @user && @user == current_user
        flash[:alert] = "You don't have access to that!"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auth_params
      params.require(:auth).permit(:name, :email, :password, :password_confirmation, :user_id)
    end
end
