class ChangeAuthUidColumnType < ActiveRecord::Migration
  def change
    change_column :auths, :uid, :string
  end
end
