class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :region_id
      t.integer :city_id
      t.integer :ptype_id
      t.decimal :minprice
      t.decimal :maxprice
      t.integer :pcategory_id
      t.integer :minarea
      t.integer :maxarea
      t.integer :material_id
      t.integer :floor
      t.integer :floors
      t.integer :room_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
