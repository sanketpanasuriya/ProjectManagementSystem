class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.references :project
      t.string :title
      t.text :description
      t.string :type
      t.string :status
      t.references :creator
      t.references :employee
      t.timestamps
    end
    add_foreign_key :issues, :projects, column: :project_id
    add_foreign_key :issues, :users, column: :creator_id
    add_foreign_key :issues, :users, column: :employee_id

  end
end
