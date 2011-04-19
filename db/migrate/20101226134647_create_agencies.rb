class CreateAgencies < ActiveRecord::Migration
  def self.up
    create_table :agencies do |t|
      t.string :agency_name
      t.string :phone1
      t.string :phone2
      t.string :fax
      t.string :email
      t.string :website
      t.string :contact_fname
      t.string :contact_lname
      t.integer :region_id
      t.integer :city_id
      t.integer :district_id

      t.timestamps
    end
  end

  def self.down
    drop_table :agencies
  end
end
