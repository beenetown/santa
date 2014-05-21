class AddSpendingLimitToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :spending_limit, :decimal, precision: 8, scale: 2
  end
end
