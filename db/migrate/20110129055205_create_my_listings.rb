class CreateMyListings < ActiveRecord::Migration
  def self.up
    create_table :my_listings do |t|
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :my_listings
  end
end
