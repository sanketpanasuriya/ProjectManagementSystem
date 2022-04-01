class CreateHours < ActiveRecord::Migration[7.0]
  def change
    create_table :hours do |t|
      t.datetime :starting
      t.datetime :ending
      t.references :task
      t.timestamps
    end

    add_foreign_key :hours, :tasks, column: :task_id
  end
end
