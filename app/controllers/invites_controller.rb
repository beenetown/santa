class InvitesController < ApplicationController
  def create
    @group = Group.find(params[:id])
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

  def destroy
    @user = User.find(params[:id])
    @group = Group.find(params[:group_id])
    user_ids = @group.user_ids 
    user_ids << @user.id
    @group.update(user_ids: user_ids)

    Invite.find_by(user_id: @user.id).destroy
    
    redirect_to @user
  end
end
