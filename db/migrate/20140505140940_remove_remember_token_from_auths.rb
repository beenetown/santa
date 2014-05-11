class RemoveRememberTokenFromAuths < ActiveRecord::Migration
  def change
    remove_column :auths, :remember_token
  end
end
