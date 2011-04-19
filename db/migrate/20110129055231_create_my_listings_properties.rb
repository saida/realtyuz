class CreateMyListingsProperties < ActiveRecord::Migration
  def self.up
    create_table :my_listings_properties do |t|
      t.integer :property_id
      t.integer :my_listings_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_listings_properties
  end
end
