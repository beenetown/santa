class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :provider
      t.integer :uid
      t.string :name

      t.timestamps
    end
    add_index :auths, :uid
    add_index :auths, [:uid, :provider], unique: true
  end
end
