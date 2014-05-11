class IndexAuthsEmail < ActiveRecord::Migration
  def change
    add_index :auths, :email
  end
end
