class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.string :stuff_file_name
      t.string :stuff_content_type #mime type
      t.integer :stuff_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
