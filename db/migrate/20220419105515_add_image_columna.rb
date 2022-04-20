class AddImageColumna < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_image, :string
  end
end
