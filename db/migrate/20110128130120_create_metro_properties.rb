class CreateMetroProperties < ActiveRecord::Migration
  def self.up
    create_table :metro_properties do |t|
      t.integer :metro_id
      t.integer :property_id
      t.integer :transport_id
      t.integer :minutes

      t.timestamps
    end
  end

  def self.down
    drop_table :metro_properties
  end
end
