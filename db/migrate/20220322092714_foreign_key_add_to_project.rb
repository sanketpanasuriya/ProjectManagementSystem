# frozen_string_literal: true

class ForeignKeyAddToProject < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :creator, null: false # remove foreign
    add_reference :projects, :client, null: false

    add_foreign_key :projects, :users, column: :creator_id
    add_foreign_key :projects, :users, column: :client_id
  end
end
