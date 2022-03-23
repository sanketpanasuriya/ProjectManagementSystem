# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :staus, null: false
      t.date :endingdate, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end
