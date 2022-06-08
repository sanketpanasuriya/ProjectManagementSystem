class CreateTaggables < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|

      t.references :tag, index: true, foreign_key: true
      t.references :taggable, polymorphic: true  
      t.timestamps
    end
  end
end
