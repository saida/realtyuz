class RemoveTypeFromSchools < ActiveRecord::Migration
  def self.up
    remove_column :schools, :type
  end

  def self.down
    add_column :schools, :type, :string
  end
end
