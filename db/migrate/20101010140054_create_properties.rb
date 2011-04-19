class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.integer :property_id
      t.integer :seller_id
      t.integer :city_id
      t.integer :district_id
      t.integer :ptype_id
      t.decimal :area
      t.integer :price
      t.string :material
      t.integer :rooms
      t.integer :floor
      t.integer :floors
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :properties
  end
end
