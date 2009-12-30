class AddCategoryIdToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :category_id, :integer
  end

  def self.down
    remove_column :pics, :category_id
  end
end
