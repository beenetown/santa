module GroupsHelper
  def current_user_is_group_owner
    current_user && @group.owner == current_user
  end

  def current_user_is_group_member
    current_user && @group.user_ids.include?(current_user.id)
  end
end
