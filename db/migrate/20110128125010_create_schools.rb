class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
      t.string :type
      t.integer :region_id
      t.integer :city_id
      t.integer :district_id
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
