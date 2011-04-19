class AddCoordsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :longitude, :float
    add_column :properties, :latitude, :float
  end

  def self.down
    drop_column :properties, :longitude
    drop_column :properties, :latitude
  end
end