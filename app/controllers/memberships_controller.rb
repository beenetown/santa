class MembershipsController < ApplicationController
  def create
    @group = Group.find(params[:id])
    @user = User.find_by(email: params[:email])
    respond_to do |format|
      if @user
        @group.users << @user
        format.html { redirect_to @user, notice: 'You joined #{@group.name}.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @group, error: 'Something went wrong! Please, try that again.' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @group = Group.find(params[:group_id])
    @user = User.find(params[:id])

    #reassign gift
    # if Time.now.to_date > @group.select_date
      reassign_gift(@group, @user)
    # end

    group_user = Membership.find_by(user_id: @user.id, group_id: @group.id)
    group_user.destroy

    flash[:notice] = "#{@user.view_name} was removed from the group!"
    redirect_to :back
  end

  private
    def reassign_gift(group, user)
      gift_to_user = Gift.find_by(group_id: group.id, giftee_id: user.id)
      gift_from_user = Gift.find_by(group_id: group.id, gifter_id: user.id)

      gift_to_user.update(giftee_id: gift_from_user.giftee_id)
      gift_from_user.destroy
    end
end
