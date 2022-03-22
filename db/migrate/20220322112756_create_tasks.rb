class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.references :sprint
      t.references :user
      t.date :due_date
      t.string :status
      t.date :status_update_date 
      t.text :description
      t.string :task_type
      t.timestamps
    end
    add_foreign_key :tasks,:sprints,column: :sprint_id
    add_foreign_key :tasks,:users,column: :user_id
    
  end
end
