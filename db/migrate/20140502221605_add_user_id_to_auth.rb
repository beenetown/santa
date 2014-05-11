class AddUserIdToAuth < ActiveRecord::Migration
  def change
    add_column :auths, :user_id, :string
  end
end
