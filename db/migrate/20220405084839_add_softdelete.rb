class AddSoftdelete < ActiveRecord::Migration[7.0]
  def change

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at

    add_column :tasks, :deleted_at, :datetime
    add_index :tasks, :deleted_at

    add_column :sprints, :deleted_at, :datetime
    add_index :sprints, :deleted_at

    add_column :issues, :deleted_at, :datetime
    add_index :issues, :deleted_at
  end
end
