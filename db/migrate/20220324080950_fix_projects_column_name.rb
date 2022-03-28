class FixProjectsColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :projects, :staus, :status
  end
end
