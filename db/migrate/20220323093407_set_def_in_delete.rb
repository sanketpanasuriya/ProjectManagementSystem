class SetDefInDelete < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :delete_user, :boolean, default: false
  end
end
