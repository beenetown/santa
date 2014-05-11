class DropGifteeIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :giftee_id
  end
end
