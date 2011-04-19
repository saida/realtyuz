class AddRoomToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :room_id, :integer
  end

  def self.down
    remove_column :properties, :room_id
  end
end
