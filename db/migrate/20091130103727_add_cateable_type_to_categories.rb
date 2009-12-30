class AddCateableTypeToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :cateable_type, :string
  end

  def self.down
    remove_column :categories, :cateable_type
  end
end
