class AddDescriptionToAttaching < ActiveRecord::Migration
  def self.up
    add_column :attachings, :description, :string
  end

  def self.down
    remove_column :attachings, :description
  end
end
