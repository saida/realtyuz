class AddIsCorporateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :isCorporate, :boolean
  end

  def self.down
    remove_column :users, :isCorporate
  end
end
