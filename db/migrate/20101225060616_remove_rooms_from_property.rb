class RemoveRoomsFromProperty < ActiveRecord::Migration
  def self.up
    remove_column :properties, :rooms
  end

  def self.down
    add_column :properties, :rooms, :integer
  end
end
