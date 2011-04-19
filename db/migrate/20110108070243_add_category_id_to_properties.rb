class AddCategoryIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :category_id, :integer
  end

  def self.down
    remove_column :properties, :category_id
  end
end
