class AddColumnDelete < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :delete_user, :boolean
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email") :projects, :client,null: false
  end
end
