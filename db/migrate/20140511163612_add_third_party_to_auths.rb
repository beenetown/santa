class AddThirdPartyToAuths < ActiveRecord::Migration
  def change
    add_column :auths, :third_party, :boolean, default: false
  end
end
