class AuthsController < ApplicationController
  before_action :set_auth, only: [:update, :destroy]
  before_action :signed_in_user, except: [:new, :create]
  # before_action :correct_user #need to implement

  def index
    @auths = Auth.where(user_id: params[:user_id]).to_a
    @user = User.find_by(params[:user_id])
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
    # if signed_in? 
      @auth = Auth.find(params[:id])
      
      if @auth.provider != 'santa'
        flash[:alert] = "That account must be updated through #{@auth.provider.split('_').first.capitalize}."
        redirect_to user_auths_path(current_user)
      end
    # else !signed_in?
    #   flash[:alert] = "You are not signed in!"
    #   redirect_to users_path
    # end
  end

  def update

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
      if @auth.user == current_user
        true
      else
        flash[:alert] = "You don't have access to that!"
        redirect_to :back
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auth_params
      params.require(:auth).permit(:name, :email, :password, :password_confirmation)
    end
end
