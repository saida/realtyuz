class AddMaterialIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :material_id, :integer
  end

  def self.down
    remove_column :properties, :material_id
  end
end
