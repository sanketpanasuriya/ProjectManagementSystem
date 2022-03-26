class ReviewRatingAdd < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :reviews, :text
    add_column :projects, :rating, :integer
    
  end
end
