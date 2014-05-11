class UsersController < ApplicationController 

  before_action :set_user, only: [:show, :edit, :update, :destroy, :accept_invite]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @gifts = @user.gifts
    @groups = @user.groups
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        # UserMailer.signup_confirmation(@user).deliver
        format.html { redirect_to @user, notice: 'Welcome to Secret Santa App!' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def accept_invite
    @group = Group.find(params[:group_id])
    user_ids = @group.user_ids 
    user_ids << @user.id
    @group.update(user_ids: user_ids)

    Invite.find_by(user_id: @user.id).destroy
    
    redirect_to @user
  end

    def add_user
    user = User.find_by(email: params[:email])
    user_id = user.id if user
    user_ids = @group.user_ids
    user_ids << user_id
    respond_to do |format|
      unless user_id.nil?
        @group.update(user_ids: user_ids)
        # @group.uuser_ids << user_id
        format.html { redirect_to @group, notice: 'User was successfully added.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @group, error: 'That user does not exist!' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end
