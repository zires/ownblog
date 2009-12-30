class RemoveStuffFormArticles < ActiveRecord::Migration
  def self.up
     remove_column :articles, :stuff_file_name
     remove_column :articles, :stuff_content_type
     remove_column :articles, :stuff_file_size
     remove_column :articles, :stuff_updated_at
  end

  def self.down
  end
end
