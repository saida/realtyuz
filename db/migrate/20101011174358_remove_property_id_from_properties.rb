class RemovePropertyIdFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :property_id
  end

  def self.down
    add_column :properties, :property_id, :integer
  end
end
