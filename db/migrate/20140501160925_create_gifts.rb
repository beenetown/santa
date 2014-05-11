class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :gifter_id
      t.integer :giftee_id
      t.integer :group_id

      t.timestamps
    end
    add_index :gifts, :gifter_id
    add_index :gifts, :giftee_id
    add_index :gifts, [:giftee_id, :gifter_id, :group_id], unique: true
  end
end
