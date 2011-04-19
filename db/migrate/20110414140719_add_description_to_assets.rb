class AddDescriptionToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :description, :string
  end

  def self.down
    remove_column :assets, :description
  end
end
