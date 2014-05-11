class AddSelectAndOpenDatesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :select_date, :date
    add_column :groups, :open_date, :date
  end
end
