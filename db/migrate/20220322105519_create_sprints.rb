class CreateSprints < ActiveRecord::Migration[7.0]
  def change
    create_table :sprints do |t|
      t.references :project
      t.string :title
      t.date :expected_end_date
      t.text :description
      t.timestamps
    end
    add_foreign_key :sprints, :projects,column: :project_id
  end
  
end
