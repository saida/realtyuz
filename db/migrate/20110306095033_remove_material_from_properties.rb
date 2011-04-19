class RemoveMaterialFromProperties < ActiveRecord::Migration
  def self.up
    remove_column :properties, :material
  end

  def self.down
    add_column :properties, :material, :string
  end
end
