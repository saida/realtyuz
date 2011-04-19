class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :utype_id
      t.integer :broker_id 
      t.string :fname
      t.string :lname
      t.string :mobphone
      t.string :workphone
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.string :website
      t.string :cotitle

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
