# frozen_string_literal: true

class Create < ActiveRecord::Migration[7.0]
  def change
    create_table :costs do |t|
      t.references :project
      t.integer :total_cost
    end
    add_foreign_key :costs, :projects, column: :project_id
  end
end
