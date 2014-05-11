class AddEmailAndPasswordDigestToAuths < ActiveRecord::Migration
  def change
    add_column :auths, :email, :string
    add_column :auths, :password_digest, :string
  end
end
