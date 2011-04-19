class CreateMetros < ActiveRecord::Migration
  def self.up
    create_table :metros do |t|
      t.string :name
      t.integer :region_id
      t.integer :city_id
      t.integer :district_id

      t.timestamps
    end
  end

  def self.down
    drop_table :metros
  end
end
