class GroupsController < ApplicationController

  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_user, :invite_user, :select_date, :open_date]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @users = @group.users
  end

  # GET /groups/new
  def new
    @group = Group.new
    @user = current_user if current_user
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @user = current_user if current_user
    @group.user_ids = @user.id

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
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

  def invite_user
    auth = Auth.find_by(email: params[:email])
    @user = auth.user if auth
     
     if @user
       UserMailer.invite_to_group(params[:email], @group, @user).deliver #if Rails.env.production?
       @invite = Invite.create(user_id: @user.id, group_id: @group.id)
       redirect_to @group, notice: "Invitation was sent to #{params[:email]}"
     else
        # create a temporary account
        user = User.create(guest: true)
        password = User.temp_password
        auth = Auth.create(provider: "santa",
                          user_id: user.id,
                          email: params[:email],
                          password: password,
                          password_confirmation: password)
        invite = Invite.create(user_id: user.id, group_id: @group.id)

        UserMailer.invite_new_user(params[:email], @group, user, password).deliver
        redirect_to @group, notice: "#{params[:email]} does not have a Secret Santa account. An invitation to join was sent."
     end
  end

  def select_date
    @group.select_date = params[:group][:select_date]
    if @group.save
      redirect_to @group
    else
      redirect_to @group
    end
  end

  def open_date
    @group.open_date = params[:group][:open_date]
    if @group.save
      redirect_to @group
    else
      redirect_to @group
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :owner_id, :select_date, :open_date)
    end
end
