class AddDetailsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :details, :text
  end

  def self.down
    drop_column :properties, :details
  end
end