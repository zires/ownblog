class CreatePics < ActiveRecord::Migration
  def self.up
    create_table :pics do |t|
      t.string  :title, :null => true
      t.text :description 
      t.timetamps
    end
  end

  def self.down
    drop_table :pics
  end
end
