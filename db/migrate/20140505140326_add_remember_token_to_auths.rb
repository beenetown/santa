class AddRememberTokenToAuths < ActiveRecord::Migration
  def change
    add_column :auths, :remember_token, :string
  end
end
