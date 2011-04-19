class AddRegionIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :region_id, :integer
  end

  def self.down
    remove_column :properties, :region_id
  end
end
