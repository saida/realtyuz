class AddAddressToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :address, :text
  end

  def self.down
    drop_column :properties, :address, :text
  end
end
