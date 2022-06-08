class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :tag_type
      t.string :tag_name
      t.string :color
      t.timestamps 
    end
  end
end
