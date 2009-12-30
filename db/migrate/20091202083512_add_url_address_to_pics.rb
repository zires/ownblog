class AddUrlAddressToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :url_address, :string
  end

  def self.down
    remove_column :pics, :url_address
  end
end
