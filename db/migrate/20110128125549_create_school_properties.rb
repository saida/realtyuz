class CreateSchoolProperties < ActiveRecord::Migration
  def self.up
    create_table :school_properties do |t|
      t.integer :school_id
      t.integer :property_id
      t.integer :transport_id
      t.integer :minutes

      t.timestamps
    end
  end

  def self.down
    drop_table :school_properties
  end
end
