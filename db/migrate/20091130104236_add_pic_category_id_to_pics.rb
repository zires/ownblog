class AddPicCategoryIdToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :pic_category_id, :integer
  end

  def self.down
    remove_column :pics, :pic_category_id
  end
end
